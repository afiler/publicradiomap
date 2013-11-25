require 'digest/md5'

class Broadcaster < ActiveRecord::Base
  belongs_to :parent, class_name: 'Broadcaster'
  has_many :children, class_name: 'Broadcaster', foreign_key: 'parent_id'
  belongs_to :facility
  self.rgeo_factory_generator = RGeo::Geographic.spherical_factory(:srid => 4326)
  acts_as_taggable_on :formats

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
    @licensee ||= facility.licensee if facility
  end
  
  def licensee_name
    licensee.name if licensee
  end

  def contour
    return JSON.parse(contour_geojson) if contour_geojson.present?
    
    puts "fetching contour"
    self.contour_geojson = ActiveRecord::Base.connection.select_all(%Q{
      select ST_AsGeoJSON(contour) as contour from broadcasters where id=#{id}
    }).first['contour']
    save
    
    #return JSON.parse(contour_geojson)
    x = JSON.parse(contour_geojson)
    
    
    # require 'pry'
    # binding.pry
    # 
    if x['type'] == 'Polygon'
      x['type'] = 'LineString'
      x['coordinates'] = x['coordinates'][0]
    end
    
    return x
  end
  
  def display_name
    #name.present? ? name : parent ? parent.display_name : licensee_name ? licensee_name : callsign
    if name.present?
      name
    elsif parent
      parent.display_name
    elsif licensee_name
      licensee_name
    else
      "#{callsign} - #{community}" 
    end
  end
  
  def subtitle
    return read_attribute(:subtitle) if read_attribute(:subtitle).present?
    return parent.subtitle if parent
    
    subtitle = if display_name =~ /^[KW][A-Z]{2,3}(-[AF]M)?$/ 
      community || Broadcaster.find_by_callsign(display_name).community rescue nil
    else
      nil
    end
    
    write_attribute(:subtitle, subtitle)
    save
    
    subtitle
  end

  def color
    return read_attribute(:color) if read_attribute(:color).present?
    return parent.color if parent
    
    write_attribute :color, "##{Digest::MD5.hexdigest(display_name)[0..5]}"
    save
    
    read_attribute :color
  end
  
  def name_and_optional_callsign
    if callsign and callsign.to_s.start_with? display_name
      "#{display_name}"
    else
      "#{display_name} / #{callsign}"
    end
  end
  
  def summary
    "#{name_and_optional_callsign} / #{frequency} / #{(facility && facility.comm_city) || community}"
  end
  
end
