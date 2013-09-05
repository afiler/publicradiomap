class Party < ActiveRecord::Base
  has_many :facilities_parties
  has_many :facilities, through: :facilities_parties
  has_many :broadcasters, through: :facilities
end
