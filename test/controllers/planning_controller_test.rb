require 'test_helper'

class PlanningControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "print" do
    post :auto_solve
    assert true
  end
end
