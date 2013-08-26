class Facility < ActiveRecord::Base
  belongs_to :assoc_facility, class_name: 'Facility'
  has_many :facilities_parties
  has_many :parties, through: :facilities_parties
  
  def licensee
    facilities_parties.where(party_type: 'LICEN').first.party
  rescue
    nil
  end
end
