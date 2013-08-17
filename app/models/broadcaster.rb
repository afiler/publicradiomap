class Broadcaster < ActiveRecord::Base
  belongs_to :parent, class_name: 'Broadcaster'
  belongs_to :facility
  
  def display_name
    name.present? ? name : parent.display_name
  end
  
  def self.find_by_callsign(str)
    Broadcaster.find_by(callsign: str) ||
      if str =~ /(.+)-([^-]+)/
        Broadcaster.find_by(callsign: $1, band: $2)
      else
        Broadcaster.find_by(callsign: "#{str}-FM") ||
          Broadcaster.find_by(callsign: "#{str}-AM")
      end
  end
end
