class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.integer :rate, null: false
      t.string :tracking_no
      t.integer :response_id, null: false
      t.timestamps null: false
    end
  end
end
