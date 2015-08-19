class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.integer :merchant_id
      t.integer :product_id
      t.integer :buyer_id
      t.integer :request_id
      t.timestamps null: false
    end
  end
end
