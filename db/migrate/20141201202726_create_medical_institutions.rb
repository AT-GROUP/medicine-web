class CreateMedicalInstitutions < ActiveRecord::Migration
  def change
    create_table :medical_institutions do |t|
      t.text :name
      t.text :region
      t.float :latitude
      t.float :longitude
      t.integer :surgery
      t.integer :neuro
      t.integer :burn
      t.integer :reanimation
    end
  end
end
