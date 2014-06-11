class AddHasDuplicateToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :has_duplicate, :boolean, default: false
    add_column :buildings, :geo_checked, :boolean, default: false
  end
end
