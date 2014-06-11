class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.string :agency_name
      t.string :incident_address
      t.string :address_type
      t.string :borough
      t.string :city
      t.datetime :closed_date
      t.string :community_board
      t.string :complaint_type
      t.datetime :created_date
      t.string :cross_street_1
      t.string :cross_street_2
      t.string :descriptor
      t.datetime :due_date
      t.string :facility_type
      t.float :latitude
      t.float :longitude
      t.string :location_type
      t.boolean :needs_recoding
      t.string :park_borough
      t.string :park_facility_name
      t.datetime :resolution_action_updated_date
      t.string :school_address
      t.string :school_city
      t.string :school_code
      t.string :school_name
      t.string :school_not_found
      t.string :school_number
      t.string :school_phone_number
      t.string :school_region
      t.string :school_state
      t.string :school_zip
      t.string :street_name
      t.integer :unique_key
      t.string :x_coordinate_state_plane_
      t.string :y_coordinate_state_plane_
      t.string :incident_zip

      t.timestamps
    end
  end
end
