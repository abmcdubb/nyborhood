require 'mongo'
require 'csv'
require 'pry'
require 'chronic'

class DataCollector

  attr_reader :file

  DEFAULT_FILE = "/Users/alishamcwilliams/Desktop/Development/Personal Projects/nyc_apartment_app/CSVs/311_Service_Requests_from_2010_to_Present.csv"

  def initialize(file = DEFAULT_FILE)
    @con = Mongo::Connection.new
    @db = @con['nyborhood_development']
    @complaints = @db['complaints']
    @file = file
  end

  def parse_csv()
    contents = CSV.open(file, headers: true, header_converters: :symbol)  

    contents.each do |row|
      complaint = {}

      csv_attributes = row.to_hash

      csv_attributes = csv_attributes.extract!(
                              :unique_key,    
                              :created_date,
                              :closed_date,
                              :resolution_action_updated_date,
                              :agency_name,
                              :complaint_type,
                              :descriptor,
                              :location_type,
                              :incident_zip,
                              :incident_address,
                              :street_name,
                              :cross_street_1,
                              :cross_street_2,
                              :community_board,
                              :borough,
                              :latitude,
                              :longitude)

      csv_attributes[:csv_unique_key] = csv_attributes[:unique_key] 
      csv_attributes[:created_date] = convert_date(csv_attributes[:created_date]) if csv_attributes[:created_date]
      csv_attributes[:closed_date] = convert_date(csv_attributes[:closed_date]) if csv_attributes[:closed_date]
      csv_attributes[:resolution_action_updated_date] = convert_date(csv_attributes[:resolution_action_updated_date]) if csv_attributes[:resolution_action_updated_date]
      
      puts csv_attributes.inspect
      @complaints.insert(csv_attributes)
    end
  end

  def convert_date(date)
    Chronic.parse(date)
  end
end
  
# DataCollector.new.parse_csv