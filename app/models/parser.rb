require 'json'
require 'rest_client'
require 'csv'
require 'chronic'

class Parser

COMPLAINT_FIELD_DATA = ["unique_key",
              "created_date", 
              "closed_date",
              "resolution_action_updated_date",     
              "agency_name",
              "complaint_type",
              "descriptor",
              "location_type",
              "incident_zip",
              "incident_address",
              "street_name",
              "cross_street_1",
              "cross_street_2",
              "community_board",
              "borough",
              "latitude",
              "longitude"]

  def initialize(url)
    @url = url
  end

  def response
    JSON.parse(RestClient.get(@url))
  end

  def locate_building(street_address, zipcode)
    @building = Building.find_by_address(street_address, zipcode)
  end

  def all_buildings_csv
    CSV.foreach(@url) do |row|
      new_row = row.join(",")      
        borough, block, lot, cd, ct2010, cb2010, schooldist, council, zipcode, firecomp, policeprct, address, zonedist1, zonedist2, zonedist3, zonedist4, overlay1, overlay2, spdist1, spdist2, ltdheight, allzoning1, allzoning2, splitzone, bldgclass, landuse, easements, ownertype, ownername, lotarea, bldgarea, comarea, resarea, officearea, retailarea, garagearea, strgearea, factryarea, otherarea, areasource, numbldgs, numfloors, unitsres, unitstotal, lotfront, lotdepth, bldgfront, bldgdepth, ext, proxcode, irrlotcode, lottype, bsmtcode, assessland, assesstot, exemptland, exempttot, yearbuilt, builtcode, yearalter1, yearalter2, histdist, landmark, builtfar, residfar, commfar, facilfar, borocode, bbl, condono, tract2010, xcoord, ycoord, zonemap, zmcode, sanborn, taxmap, edesignum, appbbl, appdate, plutomapid, version = new_row.split(",")
        building = Building.create(:borough => borough.strip, 
                                   :tax_block => block.strip, 
                                   :tax_lot => lot.strip, 
                                   :community_district => cd.strip, 
                                   :census_tract => ct2010.strip, 
                                   :census_block => cb2010.strip, 
                                   :school_district => schooldist.strip, 
                                   :city_council_district => council.strip, 
                                   :zip => zipcode.strip, 
                                   :fire_company => firecomp.strip, 
                                   :police_precinct => policeprct.strip, 
                                   :address => address.strip, 
                                   :zoning_district1 => zonedist1.strip, 
                                   :zoning_district2 => zonedist2.strip, 
                                   :zoning_district3 => zonedist3.strip, 
                                   :zoning_district4 => zonedist4.strip, 
                                   :zoning_commercial_overlay1 => overlay1.strip, 
                                   :zoning_commercial_overlay2 => overlay2.strip, 
                                   :zoning_special_purpose_district1 => spdist1.strip, 
                                   :zoning_special_purpose_district2 => spdist2.strip, 
                                   :zoning_limited_height_district => ltdheight.strip, 
                                   :zoning_all_components1 => allzoning1.strip, 
                                   :zoning_all_components2 => allzoning2.strip, 
                                   :split_zone => splitzone.strip, 
                                   :building_class => bldgclass.strip, 
                                   :land_use => landuse.strip, 
                                   :num_of_easements => easements.strip, 
                                   :type_of_ownership => ownertype.strip, 
                                   :owner_name => ownername.strip, 
                                   :lot_area => lotarea.strip, 
                                   :floor_area_total => bldgarea.strip, 
                                   :floor_area_commercial => comarea.strip, 
                                   :floor_area_residential => resarea.strip, 
                                   :floor_area_office => officearea.strip, 
                                   :floor_area_retail => retailarea.strip, 
                                   :floor_area_garage => garagearea.strip, 
                                   :floor_area_storage => strgearea.strip, 
                                   :floor_area_factory => factryarea.strip, 
                                   :floor_area_other => otherarea.strip, 
                                   :floor_area_area_souce => areasource.strip, 
                                   :num_of_buildings => numbldgs.strip, 
                                   :num_of_floors => numfloors.strip, 
                                   :num_of_residential_units => unitsres.strip, 
                                   :num_of_total_units => unitstotal.strip, 
                                   :lot_frontage => lotfront.strip, 
                                   :lot_depth => lotdepth.strip, 
                                   :building_frontage => bldgfront.strip, 
                                   :building_depth => bldgdepth.strip, 
                                   :extension_code => ext.strip, 
                                   :proximity_code => proxcode.strip, 
                                   :irregular_lot_code => irrlotcode.strip, 
                                   :lot_type => lottype.strip, 
                                   :basement_type_grade => bsmtcode.strip, 
                                   :assessed_land_value => assessland.strip, 
                                   :assed_total_value => assesstot.strip, 
                                   :exempt_land_value => exemptland.strip, 
                                   :exempt_total_value => exempttot.strip, 
                                   :year_built => yearbuilt.strip, 
                                   :year_built_code => builtcode.strip, 
                                   :year_altered1 => yearalter1.strip, 
                                   :year_altered2 => yearalter2.strip, 
                                   :historic_district_name => histdist.strip, 
                                   :landmark_name => landmark.strip, 
                                   :built_floor_area_ratio => builtfar.strip, 
                                   :maximum_allowable_residential_far => residfar.strip, 
                                   :maximum_allowable_commerical_far => commfar.strip, 
                                   :maximum_allowable_facility_far => facilfar.strip, 
                                   :borough_code => borocode.strip, 
                                   :borough_tax_block_lot => bbl.strip, 
                                   :condominium_number => condono.strip, 
                                   :census_tract2 => tract2010.strip, 
                                   :zoning_map_num => zonemap.strip, 
                                   :zoning_map_code => zmcode.strip,     
                                   :tax_map => taxmap.strip, 
                                   :e_designation_num => edesignum.strip, 
                                   :apportionment_bbl => appbbl.strip, 
                                   :appotionment_date => appdate.strip)
    end
  end    

  def parse_registered_buildings_txt
    buildings = File.read(@url)
    building_string = buildings.split(/[\r\n]+/)

    building_string.each do |building|
      new_bldg = building.split('|')
      if locate_building("#{new_bldg[2]} #{new_bldg[5]}", new_bldg[6])    
        @building.attributes = {:unique_building_id => new_bldg[0], :bin_number => new_bldg[9], :block_number => new_bldg[7], :community_board => new_bldg[10], :block_number => new_bldg[7], :lot_number => new_bldg[8], :management_program => new_bldg[12], :dob_building_class => new_bldg[13], :legal_stories => new_bldg[14], :legal_class_a => new_bldg[15], :legal_class_b => new_bldg[16], :registration_id => new_bldg[17], :lifecycle => new_bldg[18], :record_status => new_bldg[19]}
        @building.save
      else
        building_instance = Building.create(:unique_building_id => new_bldg[0],:borough => new_bldg[1], :address => "#{new_bldg[2]} #{new_bldg[5]}", :zip => new_bldg[6], :block_number => new_bldg[7], :lot_number => new_bldg[8], :bin_number => new_bldg[9], :community_board => new_bldg[10], :census_tract => new_bldg[11], :management_program => new_bldg[12], :dob_building_class => new_bldg[13], :legal_stories => new_bldg[14], :legal_class_a => new_bldg[15], :legal_class_b => new_bldg[16], :registration_id => new_bldg[17], :lifecycle => new_bldg[18], :record_status => new_bldg[19])
      end
    end
  end

  def parse_complaints311_json
    response.each do |item|
      complaint = Complaint.new
      COMPLAINT_FIELD_DATA.each do |field|      
        complaint.send("#{field}=", item[field]) 
      end
      complaint.save
    end
  end                                                                                                                                                                                                                                                                                                        

  def parse_complaints311_csv
    CSV.foreach(@url, headers: true, header_converters: :symbol) do |row|
      csv_attributes = row.to_hash
      csv_attributes = csv_attributes.extract!(:csv_unique_key,
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

      csv_attributes[:created_date] = convert_date(csv_attributes[:created_date]) if csv_attributes[:created_date]
      csv_attributes[:closed_date] = convert_date(csv_attributes[:closed_date]) if csv_attributes[:closed_date]
      csv_attributes[:resolution_action_updated_date] = convert_date(csv_attributes[:resolution_action_updated_date]) if csv_attributes[:resolution_action_updated_date]

      complaint = Complaint.create(csv_attributes)
    end
  end

  def smartystreets_csv
    CSV.foreach(@url) do |row|
      new_row = row.join(",")
      sequence, duplicate, deliverable, freeform, id, address, city, state, zip, firm_name, smartystreets_address, deliveryline2, urbanization, city, state, full_zip_code, ss_addresszip_code2, add_on_zipcode, pmb_unit, pmbnumber, processflag, flagreason, smartystreets_footnotes, ews, countyfips, countyname, dpvcode, dpvfootnotes, cmra, vacant, active, default_flag, lacs_ind, lacs_linkcode, lacs_linkind, delivery_point, checkdigit, delivery_point_barcode, carrier_route, record_type, ziptype, congressional_district, rdi, elotsequence, elot_sort, suite_link_match, time_zone, utc_offset, dst, latitude, longitude, precision = new_row.split(",")
      if id.to_i != 0
        building = Building.find(id)  
        building.attributes = {ss_address: smartystreets_address, zip4: add_on_zipcode, ss_footnotes: smartystreets_footnotes, latitude: latitude, longitude: longitude, ss_lat_and_long_precision: precision, geo_checked: true}
      end
    end
  end

  def convert_date(date)
    Chronic.parse(date)
  end

end


