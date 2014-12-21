class AjaxController < ApplicationController
  layout false
  def get_lpys
    @lpys = MedicalInstitution.where("latitude > :startx AND latitude < :endx AND longitude > :starty AND longitude < :endy",
            {startx: params[:startx], endx: params[:endx], starty: params[:starty], endy: params[:endy]})
  end

  def get_lpy_in_rectangle
    list = MedicalInstitution.where('latitude >= ' + params[:lower_latitude] .to_s + ' AND latitude <= ' +
                                                    params[:upper_latitude].to_s + ' AND longitude >= ' +
                                                    params[:lower_longitude].to_s + ' AND longitude <= ' +
                                                    params[:upper_longitude].to_s)
    render json: list
  end

  def get_lpy_in_rect(lower_latitude, upper_latitude, lower_longitude, upper_longitude)
    list = MedicalInstitution.where('latitude >= ' + lower_latitude .to_s + ' AND latitude <= ' +
                                                    upper_latitude.to_s + ' AND longitude >= ' +
                                                    lower_longitude.to_s + ' AND longitude <= ' +
                                                    upper_longitude.to_s)
  end

  def get_lpy_with_surgery
    if params[:lower_latitude] == nil
      lower_latitude = -1
    else
      lower_latitude = params[:lower_latitude]
    end
    if params[:upper_latitude] == nil
      lower_latitude = 200
    else
      upper_latitude = params[:upper_latitude]
    end
    if params[:lower_longitude] == nil
      lower_longitude = -1
    else
      lower_longitude = params[:lower_longitude]
    end
    if params[:upper_longitude] == nil
      upper_longitude = -1
    else
      upper_longitude = params[:upper_longitude]
    end
    list = get_lpy_in_rect(lower_latitude, upper_latitude, lower_longitude, upper_longitude)
    list_with_slots = []
    list.each do |lpy|
      if lpy.surgery > 0
        list_with_slots << lpy
      end
    end
    render json: list_with_slots
  end

  def get_lpy_with_neuro
    if params[:lower_latitude] == nil
      lower_latitude = -1
    else
      lower_latitude = params[:lower_latitude]
    end
    if params[:upper_latitude] == nil
      lower_latitude = 200
    else
      upper_latitude = params[:upper_latitude]
    end
    if params[:lower_longitude] == nil
      lower_longitude = -1
    else
      lower_longitude = params[:lower_longitude]
    end
    if params[:upper_longitude] == nil
      upper_longitude = -1
    else
      upper_longitude = params[:upper_longitude]
    end
    list = get_lpy_in_rect(lower_latitude, upper_latitude, lower_longitude, upper_longitude)
    list_with_slots = []
    list.each do |lpy|
      if lpy.neuro > 0
        list_with_slots << lpy
      end
    end
    render json: list_with_slots
  end

  def get_lpy_with_burn
    if params[:lower_latitude] == nil
      lower_latitude = -1
    else
      lower_latitude = params[:lower_latitude]
    end
    if params[:upper_latitude] == nil
      lower_latitude = 200
    else
      upper_latitude = params[:upper_latitude]
    end
    if params[:lower_longitude] == nil
      lower_longitude = -1
    else
      lower_longitude = params[:lower_longitude]
    end
    if params[:upper_longitude] == nil
      upper_longitude = -1
    else
      upper_longitude = params[:upper_longitude]
    end
    list = get_lpy_in_rect(lower_latitude, upper_latitude, lower_longitude, upper_longitude)
    list_with_slots = []
    list.each do |lpy|
      if lpy.burn > 0
        list_with_slots << lpy
      end
    end
    render json: list_with_slots
  end

  def get_lpy_with_reanimation
    if params[:lower_latitude] == nil
      lower_latitude = -1
    else
      lower_latitude = params[:lower_latitude]
    end
    if params[:upper_latitude] == nil
      lower_latitude = 200
    else
      upper_latitude = params[:upper_latitude]
    end
    if params[:lower_longitude] == nil
      lower_longitude = -1
    else
      lower_longitude = params[:lower_longitude]
    end
    if params[:upper_longitude] == nil
      upper_longitude = -1
    else
      upper_longitude = params[:upper_longitude]
    end
    list = get_lpy_in_rect(lower_latitude, upper_latitude, lower_longitude, upper_longitude)
    list_with_slots = []
    list.each do |lpy|
      if lpy.reanimation > 0
        list_with_slots << lpy
      end
    end
    render json: list_with_slots
  end

  #delete it?
  def get_lpy_in_rect_with_free_slots(lower_latitude, upper_latitude, lower_logitude, upper_longitude,
                              surgery, neuro, burns, reanimation)
    list = get_lpy_in_rectangle(lower_latitude, upper_latitude, lower_longitude, upper_longitude)
    list_with_slots = []
    list.each do |lpy|
      if (lpy.surgery >= 1 and surgery > 0) or (lpy.neuro >= 1 and neuro > 0) or
          (lpy.burn >= 1 and burns > 0) or (lpy.reanimation >= 1 and reanimation > 0)
        list_with_slots << lpy
      end
    end
    return list_with_slots
  end

  def add_new_car_locations
    #TODO
    all_lpy = MedicalInstitution.all
    all_cars = []
    timest = Time.now.to_i
    all_lpy.each do |lpy|
      car_prop = {}
      car_prop[:lat] = lpy.latitude
      car_prop[:lon] = lpy.longitude
      cnt = rand(7)
      for i in 0...cnt
        car_type = rand(3)
        if car_type == 0
          car_prop[:type] = 'A'
        end
        if car_type == 1
          car_prop[:type] = 'B'
        end
        if car_type == 2
          car_prop[:type] = 'C'
        end
        team_type = rand(3)
        #M - medic, P - paramedic, PM - paramedic/medic
        if team_type == 0
          car_prop[:team] = 'M'
        end
        if team_type == 1
          car_prop[:team] = 'P'
        end
        if team_type == 2
          car_prop[:team] = 'PM'
        end
        all_cars << car_prop
      end
    end
    cr = Car.create
    cr.locations = all_cars.to_json
    cr.time = timest
    cr.save
  end

  def get_last_cars_location
    max_interval = 60
    last_locations = Car.last

    if last_locations == nil or (last_locations != nil and last_locations.time - Time.now.to_i > max_interval)
      add_new_car_locations
      last_locations = Car.last
    end

    render json: last_locations
  end

  def get_last_cars_location_in_rectangle
    all_cars = get_last_cars_location
    cars_in_rect = []
    all_cars.each do |loc|
      if loc[:lat] >= params[:lower_latitude] and loc[:lat] <= params[:upper_latitude] and
        loc[:lon] >= params[:lower_longitude] and loc[:lon] <= params[:upper_longitude]
        cars_in_rect << loc
      end
    end
    render json: cars_in_rect
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
