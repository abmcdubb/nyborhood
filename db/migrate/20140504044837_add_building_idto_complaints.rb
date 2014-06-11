class AddBuildingIdtoComplaints < ActiveRecord::Migration
  def change
    add_column :complaints, :building_id, :integer
  end
end
