require 'test_helper'

class ReanimationsControllerTest < ActionController::TestCase
  setup do
    @reanimation = reanimations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reanimations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reanimation" do
    assert_difference('Reanimation.count') do
      post :create, reanimation: { capacity: @reanimation.capacity, end_fund: @reanimation.end_fund }
    end

    assert_redirected_to reanimation_path(assigns(:reanimation))
  end

  test "should show reanimation" do
    get :show, id: @reanimation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @reanimation
    assert_response :success
  end

  test "should update reanimation" do
    patch :update, id: @reanimation, reanimation: { capacity: @reanimation.capacity, end_fund: @reanimation.end_fund }
    assert_redirected_to reanimation_path(assigns(:reanimation))
  end

  test "should destroy reanimation" do
    assert_difference('Reanimation.count', -1) do
      delete :destroy, id: @reanimation
    end

    assert_redirected_to reanimations_path
  end
end
