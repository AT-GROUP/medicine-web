class CreateMedicalInstitutions < ActiveRecord::Migration
  def change
    create_table :medical_institutions do |t|
      t.text :name
      t.text :region
      t.float :latitude
      t.float :longitude
    end
  end
end
