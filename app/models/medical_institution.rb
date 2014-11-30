class MedicalInstitution < ActiveRecord::Base
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
  end
end
