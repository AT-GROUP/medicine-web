class MedicalInstitutionsController < ApplicationController
  active_scaffold :"medical_institution" do |conf|
  before_action :set_medical_institution, only: [:show, :edit, :update, :destroy]
  
  # GET /medical_institutions
  # GET /medical_institutions.json
  def index
    @medical_institutions = MedicalInstitution.all
  end
end
