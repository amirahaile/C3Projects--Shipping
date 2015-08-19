class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :origin
      t.string :destination
      t.string :shipper
      t.timestamps null: false
    end
  end
end
