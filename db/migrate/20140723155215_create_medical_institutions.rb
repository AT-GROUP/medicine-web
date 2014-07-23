class CreateMedicalInstitutions < ActiveRecord::Migration
  def change
    create_table :medical_institutions do |t|
      t.text :name
      t.text :region
      t.float :x_coord
      t.float :y_coord

    end
  end
end
