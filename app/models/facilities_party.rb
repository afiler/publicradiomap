class FacilitiesParty < ActiveRecord::Base
  belongs_to :facility
  belongs_to :party
end
