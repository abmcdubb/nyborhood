class AddStateAndCityToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :state, :string, default: "NY"
    add_column :buildings, :city, :string, default: "New York City"
  end
end
