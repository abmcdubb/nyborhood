require 'csv'

class CSVParser

FIELD_DATA = ["agency_name", "incident_address", "address_type", "borough", "city", "closed_date", "community_board", "complaint_type", "created_date", "cross_street_1", "cross_street_2", "descriptor", "due_date", "facility_type", "latitude", "longitude", "location_type", "needs_recoding", "park_borough", "park_facility_name", "resolution_action_updated_date", "school_address", "school_city", "school_code", "school_name", "school_not_found", "school_number", "school_phone_number", "school_region", "school_state", "school_zip", "street_name", "unique_key", "x_coordinate_state_plane_", "y_coordinate_state_plane_", "incident_zip"]

  def initialize(url)
    @url = url
  end

  def response
    JSON.parse(RestClient.get(@url))
  end

  def parse
    response.each do |item|
      complaint = Complaint.new
      FIELD_DATA.each do |field|        
        complaint.send("#{field}=", item[field]) 
      end
      complaint.save
    end
  end

  def parse_json
    binding.pry
    # response.each do |item|
    #   complaint = Complaint.new
    #   FIELD_DATA.each do |field|        
    #     complaint.send("#{field}=", item[field]) 
    #   end
    #   complaint.save
    # end
  end

  def parse_csv
    CSV.foreach('db/311_Service_Requests_from_2010_to_Present.csv') do |row|
      binding.pry 
    end
  end

end 

# n = Parser.new("db/311data.json")
# t = Parser.new("db/311_Service_Requests_from_2010_to_Present.csv")
# Parser.new("http://data.cityofnewyork.us/resource/erm2-nwe9.json")