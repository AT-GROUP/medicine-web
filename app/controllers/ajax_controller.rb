class AjaxController < ApplicationController
  layout false
  Max_interval = 60
  def get_lpys
    @lpys = MedicalInstitution.where("latitude > :startx AND latitude < :endx AND longitude > :starty AND longitude < :endy",
            {startx: params[:startx], endx: params[:endx], starty: params[:starty], endy: params[:endy]})
  end

  def get_lpy_in_rectangle(lower_latitude, upper_latitude, lower_longitude, upper_longitude)
    list = MedicalInstitution.where('latitude >= ' + lower_latitude.to_s + ' AND latitude <= ' +
                                                    upper_latitude.to_s + ' AND longitude >= ' +
                                                    lower_longitude.to_s + ' AND longitude <= ' +
                                                    upper_longitude.to_s)
    return list
  end

  def get_lpy_in_rect_with_free_slots(lower_latitude, upper_latitude, lower_logitude, upper_longitude,
                              surgery, neuro, burns, reanimation)
    list = get_lpy_in_rectangle(lower_latitude, upper_latitude, lower_longitude, upper_longitude)
    list_with_slots = []
    list.each do |lpy|
      if (lpy.surgery >= surgery and surgery > 0) or (lpy.neuro >= neuro and neuro > 0) or
          (lpy.burns >= burns and burns > 0) or (lpy.reanimation >= reanimation and reanimation > 0)
        list_with_slots << lpy
      end
    end

    return list_with_slots
  end

  def add_new_car_locations
    #TODO
    all_lpy = MedicalInstitution.all
    car_locations = []
    timst = Time.now.to_i
    all_lpy.each do |lpy|
      coords = {}
      coords[:lat] = lpy.latitude
      coords[:lon] = lpy.longitude
      cnt = rand(7)
      for i in 0...cnt
        car_locations << coords
      end
    end
    Car.create(car_locations.to_s, timest)
  end

  def get_last_cars_location
    last_locations = Car.last

    if last_locations == nil or last_locations.time - Time.now.to_i > Max_interval
      add_new_car_locations
      last_locations = Car.last
    end

    return last_locations
  end

  def get_last_cars_location_in_rectangle(lower_latitude, upper_latitude, lower_longitude, upper_longitude)
    all_cars = get_last_cars_location
    cars_in_rect = []
    all_cars.each do |loc|
      if loc[:lat] >= lower_latitude and loc[:lat] <= upper_latitude and
        loc[:lon] >= lower_longitude and loc[:lon] <= upper_longitude
        cars_in_rect << loc
    end
    return cars_in_rect
  end

  def get_closest_car_state(time_to_find)
    #time_to_find --- UNIX time
    all_cars = Car.all
    if all_car.length == 0
      return nil
    end
    closest = all_cars[0]
    all_cars.each do |state|
      if (closest.time - time_to_find).abs > (state.time - time_to_find).abs or
          ((closest.time - time_to_find).abs == (state.time - time_to_find).abs and closest.time > state.time)
        closest = state
      end
    end
    return closest
  end
end
