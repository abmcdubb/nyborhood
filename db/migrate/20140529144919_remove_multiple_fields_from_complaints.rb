class RemoveMultipleFieldsFromComplaints < ActiveRecord::Migration
  def change
    remove_column :complaints, :school_address
    remove_column :complaints, :school_city
    remove_column :complaints, :school_code
    remove_column :complaints, :school_name
    remove_column :complaints, :school_not_found
    remove_column :complaints, :school_number
    remove_column :complaints, :school_phone_number
    remove_column :complaints, :school_region
    remove_column :complaints, :school_state
    remove_column :complaints, :school_zip
    remove_column :complaints, :x_coordinate_state_plane_
    remove_column :complaints, :y_coordinate_state_plane_
    remove_column :complaints, :due_date
    remove_column :complaints, :park_borough
    remove_column :complaints, :park_facility_name
    remove_column :complaints, :address_type
  end
end

