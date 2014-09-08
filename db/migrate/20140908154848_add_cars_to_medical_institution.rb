class AddCarsToMedicalInstitution < ActiveRecord::Migration
  def change
    add_column :medical_institutions, :reanimobile, :integer
    add_column :medical_institutions, :ambulance, :integer
  end
end
