class Facility < ActiveRecord::Base
  belongs_to :assoc_facility, class_name: 'Facility'
  has_many :facilities_parties
  has_many :parties, through: :facilities_parties
  has_one :broadcaster
  
  def self.find_by(options)
    puts "Facility.find_by(#{options.pretty_inspect.strip})"
  
    options[:fac_callsign] = options.delete :callsign if options[:callsign]
    options[:fac_service] = options.delete :band if options[:band]
  
    super options
  end
  
  def community
    comm_city
  end
  
  def callsign
    fac_callsign
  end
  
  def band
    fac_service
  end
  
  def frequency
    fac_frequency
  end

  def licensee
    facilities_parties.where(party_type: 'LICEN').first.party
  rescue
    nil
  end
  
  def create_broadcaster(options={})
    return if Broadcaster.where(facility_id: self.id).length > 0
    
    options.merge! facility: self, callsign: self.fac_callsign, community: self.comm_city.titlecase,
      band: self.band, frequency: self.frequency

    b = Broadcaster.create options
    b.build_contour
    
    b
  end
end