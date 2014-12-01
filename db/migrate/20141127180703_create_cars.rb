class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.text :locations
      t.integer :time
    end
  end
end
