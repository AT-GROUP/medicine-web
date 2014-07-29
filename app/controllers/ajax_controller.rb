class AjaxController < ApplicationController
  layout false
  
  def get_lpys
    @lpys = MedicalInstitution.where("x_coord > :startx AND x_coord < :endx AND y_coord > :starty AND y_coord < :endy",
            {startx: params[:startx], endx: params[:endx], starty: params[:starty], endy: params[:endy]})
  end
end
