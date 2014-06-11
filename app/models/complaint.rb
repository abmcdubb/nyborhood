class Complaint 
  include Mongoid::Document
  include Mongoid::Timestamps

  field :building_id, type: String
  field :incident_address, type: String
  field :incident_zip, type: String
  field :latitude, type: Float
  field :longitude, type: Float
  field :cross_street_1, type: String
  field :cross_street_2, type: String
  field :complaint_type, type: String
  field :descriptor, type: String
  field :agency_name, type: String
  field :borough, type: String
  field :created_date, type: DateTime
  field :closed_date, type: DateTime
  field :community_board, type: String  
  field :facility_type, type: String
  field :location_type, type: String
  field :city, type: String
  field :csv_unique_key, type: String
  field :needs_recoding, type: Boolean
  field :resolution_action_updated_date, type: DateTime
  field :street_name, type: String

  index({ incident_address: 1, incident_zip: 1 }, { background: true})
  index({ borough: 1}, { background: true})

  validates :csv_unique_key, uniqueness: true, presence: true
  # scope :has_address, -> { where.not(incident_address: nil) }
  belongs_to :building, index: true
  
  def self.match_to_building 
    self.has_address.where(building_id: nil).each do |complaint|
      building = complaint.locate_building(complaint.incident_address, complaint.incident_zip)
      complaint.building = building if building 
      complaint.save     
    end
  end

  def self.find_by_address(address, zip)
    Complaint.where(incident_address: address, incident_zip: zip)
  end

  def self.complaints_by_building(building_id)
    Complaint.collection.aggregate([ {"$match" => {building_id: building_id}}, {"$group" => {_id: "$descriptor", count: {"$sum" => 1}}}, {"$sort" => {count: -1}}, {"$limit" => 5}])
  end


  def self.complaint_by_borough(borough)
    self.where(borough: borough)
  end

end