class BuildingsController < ApplicationController
include BuildingsHelper 

  def index
    if params.include?("building") && !params["building"]["address"].blank?
      address = standardize_address_input(params["building"]["address"])  
      @building = Building.search_by_address(address) if params.include?("building")
      @complaint_count = @building.complaints.count
      @top_5_complaints = Complaint.complaints_by_building(@building.id)

      @gmail_query = @building.address.gsub(' ', '+') + "+#{@building.zip}"
    end
  end
end
