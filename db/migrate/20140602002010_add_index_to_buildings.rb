class AddIndexToBuildings < ActiveRecord::Migration
  def change
    add_index :buildings, :address
  end
end
