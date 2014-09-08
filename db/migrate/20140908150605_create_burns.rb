class CreateBurns < ActiveRecord::Migration
  def change
    create_table :burns do |t|
      t.integer :capacity
      t.integer :end_fund

      t.timestamps
    end
  end
end
