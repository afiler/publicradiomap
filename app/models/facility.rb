class Facility < ActiveRecord::Base
  belongs_to :assoc_facility, class_name: 'Facility'
  has_many :facilities_parties
  has_many :parties, through: :facilities_parties
  has_one :broadcaster
  
  def licensee
    facilities_parties.where(party_type: 'LICEN').first.party
  rescue
    nil
  end
  
  def create_broadcaster(options={})
    return if Broadcaster.where(facility_id: self.id).length > 0
    
    options.merge! facility: self, callsign: self.fac_callsign, community: self.comm_city
    Broadcaster.create options
  end
end
