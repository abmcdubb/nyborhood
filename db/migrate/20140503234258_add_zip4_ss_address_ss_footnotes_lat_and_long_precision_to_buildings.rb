class AddZip4SsAddressSsFootnotesLatAndLongPrecisionToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :zip4, :string
    add_column :buildings, :ss_address, :string
    add_column :buildings, :ss_footnotes, :string
    add_column :buildings, :ss_lat_and_long_precision, :string
  end
end
