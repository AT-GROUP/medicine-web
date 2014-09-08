require 'test_helper'

class BurnsControllerTest < ActionController::TestCase
  setup do
    @burn = burns(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:burns)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create burn" do
    assert_difference('Burn.count') do
      post :create, burn: { capacity: @burn.capacity, end_fund: @burn.end_fund }
    end

    assert_redirected_to burn_path(assigns(:burn))
  end

  test "should show burn" do
    get :show, id: @burn
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @burn
    assert_response :success
  end

  test "should update burn" do
    patch :update, id: @burn, burn: { capacity: @burn.capacity, end_fund: @burn.end_fund }
    assert_redirected_to burn_path(assigns(:burn))
  end

  test "should destroy burn" do
    assert_difference('Burn.count', -1) do
      delete :destroy, id: @burn
    end

    assert_redirected_to burns_path
  end
end
