class CreateSurgeries < ActiveRecord::Migration
  def change
    create_table :surgeries do |t|
      t.integer :capacity
      t.integer :end_fund

      t.timestamps
    end
  end
end
