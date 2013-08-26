class Broadcaster < ActiveRecord::Base
  belongs_to :parent, class_name: 'Broadcaster'
  belongs_to :facility
  self.rgeo_factory_generator = RGeo::Geographic.spherical_factory(:srid => 4326)

  def self.find_by_callsign(str)
    Broadcaster.find_by(callsign: str) ||
      if str =~ /(.+)-([^-]+)/
        Broadcaster.find_by(callsign: $1, band: $2)
      else
        Broadcaster.find_by(callsign: "#{str}-FM") ||
          Broadcaster.find_by(callsign: "#{str}-AM")
      end
  end
  
  def licensee
    facility.licensee
  end
  
  def licensee_name
    l = licensee
    l.name if l
  end

  def contour
    JSON.parse ActiveRecord::Base.connection.select_all(%Q{
      select ST_AsGeoJSON(contour) as contour from broadcasters where id=#{id}
    }).first['contour']
  rescue
    nil
  end
  
  def display_name
    name.present? ? name : parent ? parent.display_name : licensee_name ? licensee_name : callsign
  end
  
  def name_and_optional_callsign
    if callsign and callsign.to_s.start_with? display_name
      "#{display_name}"
    else
      "#{display_name} / #{callsign}"
    end
  end
  
  def summary
    "#{licensee_name} / #{name_and_optional_callsign} / #{frequency} / #{facility && facility.comm_city}"
  end
  
end
