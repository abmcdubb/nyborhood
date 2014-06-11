class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.integer :unique_building_id
      t.string :address
      t.string :bin_number
      t.string :block_number 
      t.string :borough
      t.string :census_tract
      t.string :community_board
      t.string :dob_building_class
      t.string :dob_building_id     
      t.string :legal_class_a
      t.string :legal_class_b
      t.integer :legal_stories
      t.string :lifecycle
      t.string :lot_number 
      t.string :management_program
      t.string :record_status
      t.string :registration_id
      t.string :zip

      t.timestamps
    end
  end
end
