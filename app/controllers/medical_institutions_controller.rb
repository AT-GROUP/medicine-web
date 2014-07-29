class MedicalInstitutionsController < ApplicationController
  before_action :set_medical_institution, only: [:show, :edit, :update, :destroy]
  
  # GET /medical_institutions
  # GET /medical_institutions.json
  def index
    @medical_institutions = MedicalInstitution.all
  end

  # GET /medical_institutions/1
  # GET /medical_institutions/1.json
  def show
  end

  # GET /medical_institutions/new
  def new
    @medical_institution = MedicalInstitution.new
  end

  # GET /medical_institutions/1/edit
  def edit
  end

  # POST /medical_institutions
  # POST /medical_institutions.json
  def create
    @medical_institution = MedicalInstitution.new(medical_institution_params)

    respond_to do |format|
      if @medical_institution.save
        format.html { redirect_to @medical_institution, notice: 'Medical institution was successfully created.' }
        format.json { render action: 'show', status: :created, location: @medical_institution }
      else
        format.html { render action: 'new' }
        format.json { render json: @medical_institution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medical_institutions/1
  # PATCH/PUT /medical_institutions/1.json
  def update
    respond_to do |format|
      if @medical_institution.update(medical_institution_params)
        format.html { redirect_to @medical_institution, notice: 'Medical institution was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @medical_institution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medical_institutions/1
  # DELETE /medical_institutions/1.json
  def destroy
    @medical_institution.destroy
    respond_to do |format|
      format.html { redirect_to medical_institutions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medical_institution
      @medical_institution = MedicalInstitution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def medical_institution_params
      params.require(:medical_institution).permit(:name, :region, :x_coord, :y_coord)
    end
end
