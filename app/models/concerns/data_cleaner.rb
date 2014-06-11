class DataCleaner

  def update_borough_name(old_name, new_name)
    Building.where(borough: old_name).update_all(borough: new_name)
  end

  def location_update(borough)
    Building.buildings_by_borough(borough).no_timeout.each do |doc|
      if doc.longitude != nil && doc.latitude != nil
        doc.location = [doc.longitude, doc.latitude] 
        doc.save 
      end
    end
  end

  def add_building_to_complaint(borough)
    Building.buildings_by_borough(borough).no_timeout.each do |doc|
      Complaint.find_by_address(doc.address, doc.zip).no_timeout.each do |complaint|
        complaint.building_id = doc.id
        complaint.save
        doc.latitude = complaint.latitude if doc.latitude == nil
        doc.longitude = complaint.longitude if doc.longitude == nil
        doc.cross_street_1 = complaint.cross_street_1 if doc.cross_street_1 == nil
        doc.cross_street_2 = complaint.cross_street_2 if doc.cross_street_2 == nil
        doc.save
      end
    end
  end

  def add_building_to_complaint_leftovers
    Building.where(latitude: nil).no_timeout.each do |doc|
      Complaint.find_by_address(doc.address, doc.zip).no_timeout.each do |complaint|
        complaint.building_id = doc.id
        complaint.save
        doc.latitude = complaint.latitude if doc.latitude == nil
        doc.longitude = complaint.longitude if doc.longitude == nil
        doc.cross_street_1 = complaint.cross_street_1 if doc.cross_street_1 == nil
        doc.cross_street_2 = complaint.cross_street_2 if doc.cross_street_2 == nil
        doc.save
      end
    end
  end
end

#a = DataCleaner.new
#a.add_building_to_complaint('MANHATTAN')

#a.update_borough_name('MN','MANHATTAN')