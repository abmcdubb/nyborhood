class BuildingsController < ApplicationController
include BuildingsHelper 

  def index
    if params.include?("building") && !params["building"]["address"].blank?
      address = standardize_address_input(params["building"]["address"])  
      @building = Building.search_by_address(address) if params.include?("building")
        if @building
          @complaint_count = @building.complaints.count
          @top_5_complaints = Complaint.complaints_by_building(@building.id)
          @gmail_query = @building.address.gsub(' ', '+') + "+#{@building.zip}"
          flash[:notice] = nil
        else
          flash[:notice] = "No buildings in our database matched that search. Please include only house number, street name, and street type. For example: '123 Fake Street'"
        end
    end
  end
end
