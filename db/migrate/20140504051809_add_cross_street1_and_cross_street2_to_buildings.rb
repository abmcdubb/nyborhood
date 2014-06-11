class AddCrossStreet1AndCrossStreet2ToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :cross_street_1, :string
    add_column :buildings, :cross_street_2, :string
  end
end
