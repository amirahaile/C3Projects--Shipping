class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string  :name, null: false
      t.integer :rate, null: false
      t.string  :delivery_days
      t.string  :delivery_time
      
      t.timestamps null: false
    end
  end
end
