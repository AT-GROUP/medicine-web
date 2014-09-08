class CreateReanimations < ActiveRecord::Migration
  def change
    create_table :reanimations do |t|
      t.integer :capacity
      t.integer :end_fund

      t.timestamps
    end
  end
end
