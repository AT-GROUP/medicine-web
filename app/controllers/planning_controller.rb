class PlanningController < ApplicationController
  def senddtp  
    params.permit(:result)
    render text: params[:result]
  end
end
