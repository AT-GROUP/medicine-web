class AjaxController < ApplicationController
  layout false
  
  def get_lpys
    @lpys = MedicalInstitution.where("latitude > :startx AND latitude < :endx AND longitude > :starty AND longitude < :endy",
            {startx: params[:startx], endx: params[:endx], starty: params[:starty], endy: params[:endy]})
  end
end
