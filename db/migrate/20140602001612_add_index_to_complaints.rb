class AddIndexToComplaints < ActiveRecord::Migration
  def change
    add_index :complaints, :building_id
  end
end
