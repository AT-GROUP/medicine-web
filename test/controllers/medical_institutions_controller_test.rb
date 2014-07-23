require 'test_helper'

class MedicalInstitutionsControllerTest < ActionController::TestCase
  setup do
    @medical_institution = medical_institutions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:medical_institutions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create medical_institution" do
    assert_difference('MedicalInstitution.count') do
      post :create, medical_institution: { name: @medical_institution.name, region: @medical_institution.region, x_coord: @medical_institution.x_coord, y_coord: @medical_institution.y_coord }
    end

    assert_redirected_to medical_institution_path(assigns(:medical_institution))
  end

  test "should show medical_institution" do
    get :show, id: @medical_institution
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @medical_institution
    assert_response :success
  end

  test "should update medical_institution" do
    patch :update, id: @medical_institution, medical_institution: { name: @medical_institution.name, region: @medical_institution.region, x_coord: @medical_institution.x_coord, y_coord: @medical_institution.y_coord }
    assert_redirected_to medical_institution_path(assigns(:medical_institution))
  end

  test "should destroy medical_institution" do
    assert_difference('MedicalInstitution.count', -1) do
      delete :destroy, id: @medical_institution
    end

    assert_redirected_to medical_institutions_path
  end
end
