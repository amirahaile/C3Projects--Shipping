class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :request_id
      t.timestamps null: false
    end
  end
end
