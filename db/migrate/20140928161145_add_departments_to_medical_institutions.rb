class AddDepartmentsToMedicalInstitutions < ActiveRecord::Migration
  def change
    add_column :medical_institutions, :surgery, :integer
    add_column :medical_institutions, :neuro, :integer
    add_column :medical_institutions, :burn, :integer
    add_column :medical_institutions, :reanimation, :integer
  end
end
