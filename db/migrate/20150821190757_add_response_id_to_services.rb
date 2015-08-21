class AddResponseIdToServices < ActiveRecord::Migration
  def change
    add_column :services, :response_id, :integer
  end
end
