require 'test_helper'

class PlanningControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "test_auto_solve" do
    post(:senddtp, {:result => 'ok, test it'})
    assert true
  end
end
