class Building #< ActiveRecord::Base
  include Mongoid::Document
  include Mongoid::Timestamps

  field :address, type: String #using
  field :zip, type: String #using
  field :borough, type: String #using
  field :latitude, type: Float
  field :longitude, type: Float
  field :cross_street_1, type: String #USE
  field :cross_street_2, type: String #USE
  field :community_board, type: String 
  field :community_district, type: String #using
  field :fire_company, type: String #using
  field :police_precinct, type: String #using
  field :school_district, type: String #using
  field :owner_name, type: String #using
  field :year_built, type: String #using  
  field :block_number, type: String
  field :bin_number, type: String  
  field :census_tract, type: String
  field :dob_building_class, type: String
  field :dob_building_id, type: String
  field :legal_class_a, type: String
  field :legal_class_b, type: String
  field :legal_stories, type: Integer
  field :lifecycle, type: String
  field :lot_number, type: String
  field :management_program, type: String
  field :record_status, type: String
  field :registration_id, type: String
  field :tax_block, type: String
  field :tax_lot, type: String  
  field :census_block, type: String 
  field :city_council_district, type: String
  field :zoning_district1, type: String
  field :zoning_district2, type: String
  field :zoning_district3, type: String
  field :zoning_district4, type: String
  field :zoning_commercial_overlay1, type: String
  field :zoning_commercial_overlay2, type: String
  field :zoning_special_purpose_district1, type: String
  field :zoning_special_purpose_district2, type: String
  field :zoning_limited_height_district, type: String
  field :zoning_all_components1, type: String
  field :zoning_all_components2, type: String
  field :split_zone, type: String
  field :building_class, type: String #land_use
  field :land_use, type: String
  field :num_of_easements, type: String
  field :type_of_ownership, type: String #USE
  field :lot_area, type: String
  field :floor_area_total, type: String
  field :floor_area_commercial, type: String
  field :floor_area_residential, type: String
  field :floor_area_office, type: String
  field :floor_area_retail, type: String
  field :floor_area_garage, type: String
  field :floor_area_storage, type: String
  field :floor_area_factory, type: String
  field :floor_area_other, type: String
  field :floor_area_area_souce, type: String
  field :num_of_buildings, type: String
  field :num_of_floors, type: Integer #using
  field :num_of_residential_units, type: String #using
  field :num_of_total_units, type: String #using
  field :lot_frontage, type: String
  field :lot_depth, type: String
  field :building_frontage, type: String
  field :building_depth, type: String
  field :extension_code, type: String
  field :proximity_code, type: String
  field :irregular_lot_code, type: String
  field :lot_type, type: String
  field :basement_type_grade, type: String
  field :assessed_land_value, type: String
  field :assed_total_value, type: String #USE
  field :exempt_land_value, type: String
  field :exempt_total_value, type: String
  field :year_built_code, type: String
  field :year_altered1, type: String #USE
  field :year_altered2, type: String
  field :historic_district_name, type: String
  field :landmark_name, type: String
  field :built_floor_area_ratio, type: String #USE
  field :maximum_allowable_residential_far, type: String
  field :maximum_allowable_commerical_far, type: String
  field :maximum_allowable_facility_far, type: String
  field :borough_code, type: String
  field :borough_tax_block_lot, type: String
  field :condominium_number, type: String #USE
  field :census_tract2, type: String
  field :zoning_map_num, type: String
  field :zoning_map_code, type: String
  field :tax_map, type: String
  field :e_designation_num, type: String
  field :apportionment_bbl, type: String
  field :appotionment_date, type: String
  field :has_duplicate, type: Boolean, default: ->{false}
  field :geo_checked, type: Boolean, default: ->{false}
  field :location, type: Array
  field :unique_building_id, type: String
  # field :zip4, type: String
  # field :ss_address, type: String
  # field :ss_footnotes, type: String
  # field :ss_lat_and_long_precision, type: String

  index({ address: 1, zip: 1 }, { unique: true, background: true })
  
  validates :address, presence: true
  validates :zip, presence: true
  validate :verify_unique_address, on: :create
  # geocoded_by :full_address
  # after_validation :geocode, :if => :address_changed?  
  # after_rollback :update_duplicate_flag

  # default_scope {where full_address: true}
  # scope :needs_geocoding, -> {where(geo_checked: false)}
  has_many :complaints

  def update_duplicate_flag
    building = Building.find_by_address(address, zip)
    if building
      building.update_attribute(:has_duplicate, true)
    end
  end

  def verify_unique_address 
    if Building.where(address: address, zip: zip).exists?
      errors.add(:address, "duplicate address")
      false
    end
  end

  def self.to_csv(options = {})
    CSV.generate do |csv|
      headers = ["id", "address", "city", "state", "zip"]
      csv << headers
      all.each do |building|
        csv << building.attributes.values_at(*headers)
      end
    end
  end

  def full_address
    "#{self.address} #{self.borough} #{self.city}, #{self.state} #{self.zip}" 
  end

  def self.find_by_address(address, zip)
    Building.where(address: address, zip: zip).first
  end

  def self.search_by_address(address)
    if Building.find_by(address: address) != nil
      Building.find_by(address: address)
    end
  end

  def self.buildings_by_borough(borough)
    Building.where(borough: borough)
  end

end
