require 'digest/md5'

class Broadcaster < ActiveRecord::Base
  belongs_to :parent, class_name: 'Broadcaster'
  has_many :children, class_name: 'Broadcaster', foreign_key: 'parent_id'
  belongs_to :facility
  #self.rgeo_factory_generator = RGeo::Geographic.spherical_factory(:srid => 4326)
  acts_as_taggable_on :formats

  def self.find_by_callsign(str)
    find_by_callsign_with_model Broadcaster, str
  end
  
  def self.find_by_callsign_with_model(model, str)
    model.find_by(callsign: str) ||
      if str =~ /(.+)-([^-]+)/
        model.find_by(callsign: $1, band: $2)
      else
        model.find_by(callsign: "#{str}-FM") #||
          #model.find_by(callsign: "#{str}-AM")
      end
  end
  
  def self.create_from_callsign(callsign, options={})
    fail "Broadcaster already exists" if Broadcaster.find_by_callsign(callsign)
    
    facility = find_by_callsign_with_model Facility, callsign
    facility ||= find_by_callsign_with_model CaFacility, callsign
    
    return unless facility
    
    puts "** Found facility: #{facility.pretty_inspect}"
    
    options.merge! facility: (facility if facility.is_a? Facility), callsign: facility.callsign,
      frequency: facility.frequency, band: facility.band
    broadcaster = create options
    broadcaster.fetch_contours_from_web
    
    broadcaster
  end
    
  def licensee
    @licensee ||= facility.licensee if facility
  end
  
  def licensee_name
    licensee.name if licensee
  end

  def contour
    return JSON.parse(contour_geojson) if contour_geojson.present?
    
    geojson_hash = JSON.parse ActiveRecord::Base.connection.select_all(%Q{
      select ST_AsGeoJSON(contour) as contour from broadcasters where id=#{id}
    }).first['contour']
    
    if geojson_hash['type'] == 'Polygon'
      geojson_hash['type'] = 'LineString'
      geojson_hash['coordinates'] = geojson_hash['coordinates'][0]
    end
    
    self.contour_geojson = geojson_hash.to_json
    save
        
    return geojson_hash
  end
  
  def display_name
    #name.present? ? name : parent ? parent.display_name : licensee_name ? licensee_name : callsign
    if name.present?
      name
    elsif parent
      parent.display_name
    #elsif licensee_name
    #  licensee_name
    else
    #  "#{callsign} - #{community}" 
      callsign
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
  
  def fetch_contours_from_web
    require 'open-uri'
    query_url = "http://transition.fcc.gov/fcc-bin/fmq?facid=#{facility_id}"
    puts "* Fetching #{query_url}"
    
    contour_kml = get_contour_kml Nokogiri::HTML(open query_url).at("//a[text()='KML file (60 dBu)']")[:href]
    query = %Q{
      update broadcasters
      set contour=ST_GeomFromKML(?)
      where id=#{id}
    }
    sanitized = ActiveRecord::Base.send :sanitize_sql_array, [query, contour_kml]
    ActiveRecord::Base.connection.execute sanitized
    
    self
  end

  private

  def get_contour_kml(path)
    doc = Nokogiri::XML.parse(open path).remove_namespaces!
    line_string = doc.at "//Placemark[name/text()='60 dBu Service contour']/LineString"
    line_string.at('tessellate').remove
    line_string.at('altitudeMode').remove
    line_string.at('coordinates').content = line_string.at('coordinates').text.gsub(/,0 $/, '')
  
    return line_string.to_s
  end
  
end
