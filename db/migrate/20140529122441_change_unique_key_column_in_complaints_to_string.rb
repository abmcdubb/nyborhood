class ChangeUniqueKeyColumnInComplaintsToString < ActiveRecord::Migration
  def change
    change_column :complaints, :unique_key, :string
  end
end
