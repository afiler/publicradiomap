require 'digest/md5'
require 'open-uri'

class Broadcaster < ActiveRecord::Base
  belongs_to :parent, class_name: 'Broadcaster'
  has_many :children, class_name: 'Broadcaster', foreign_key: 'parent_id'
  belongs_to :facility
  #self.rgeo_factory_generator = RGeo::Geographic.spherical_factory(:srid => 4326)
  acts_as_taggable_on :formats
  
  class Error < RuntimeError; end
  class BroadcasterExistsError < Error; end

  def self.find_by_callsign(str)
    find_by_callsign_with_model Broadcaster, str
  end
  
  def self.find_by_callsign_with_model(model, str)
    model.find_by(callsign: str) ||
      if str =~ /(.+)-([^-]+)/
        model.find_by(callsign: $1, band: $2) rescue (puts $!; nil)
      else
        model.find_by(callsign: "#{str}-FM") rescue (puts $!; nil) #||
          #model.find_by(callsign: "#{str}-AM")
      end
  end
  
  def self.create_from_callsign(callsign, options={})
    #raise BroadcasterExistsError if Broadcaster.find_by_callsign(callsign)
    puts "*** #{callsign} already exists" if Broadcaster.find_by_callsign(callsign)
    
    facility = find_by_callsign_with_model CaFacility, callsign if callsign =~ /^[CV]/
    facility ||= find_by_callsign_with_model Facility, callsign if callsign =~ /^[KW]/
    
    (puts "** #{callsign} not found"; return) unless facility
    
    puts "** Found facility: #{facility.pretty_inspect}"
    
    options.merge! facility: (facility if facility.is_a? Facility), callsign: facility.callsign,
      frequency: facility.frequency, band: facility.band, community: facility.community.titlecase
      #subtitle: facility.community.titlecase
    broadcaster = create options
    broadcaster.build_contour
    
    broadcaster
  end
  
  def create_children_from_associated_facilities
    Facility.where(<<-SQL
      fac_status='LICEN' and fac_type in ('FT', 'FTB')
      and assoc_facility_id=#{facility_id}
      and id not in (select facility_id from broadcasters where facility_id is not null)
    SQL
    ).map { |f| f.create_broadcaster parent: self }
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
  
  def country
    case callsign
    when /^[KW]/
      'US'
    when /^[CV]/
      'CA'
    end
  end
  
  def spin_color
    self.color = "#%06x" % rand(0xffffff)
    save
    self.color
  end
  
  def build_contour
    if country == 'CA'
      ca_build_contour
    else
      if band == 'AM'
        build_contour_am
      else
        build_contour_fm
      end
    end
  end
  
  def ca_build_contour
    ActiveRecord::Base.connection.execute <<-SQL
      update broadcasters
      set contour=st_setsrid(wkb_geometry, 4326) from fmreg
      where (fmreg.callsign=broadcasters.callsign or fmreg.callsign=broadcasters.callsign||'-'||broadcasters.band) 
        and broadcasters.id=#{id};
      update broadcasters
      set contour=st_setsrid(wkb_geometry, 4326) from amreg
      where broadcasters.contour is null and 
        (amreg.callsign=broadcasters.callsign or amreg.callsign=broadcasters.callsign||'-'||broadcasters.band)
        and day_night='DAY' and broadcasters.id=#{id};
    SQL
    reload
  end
  
  def build_contour_am
    ActiveRecord::Base.connection.execute <<-SQL
      update broadcasters set radius_in_km=120*(power_in_watts/5000.0)
        where id=#{id} and radius_in_km is null;
        
      update broadcasters b
      set location=st_setsrid(
        st_makepoint(
          0-(lon_deg+(lon_min/60.0)+(lon_sec/3600.0)),
          lat_deg+(lat_min/60.0)+(lat_sec/3600.0)
        ), 4326)
      from fcc_am_ant_sys ant, fcc_applications app
      where b.facility_id=app.facility_id and ant.application_id=app.id
        and b.id=#{id} and b.location is null;
      
      update broadcasters b
      set contour=geometry(ST_Buffer(geography(ST_Transform(location, 4326)), radius_in_km*1000))
      where b.id=#{id};
    SQL
    reload
  end
  
  def build_contour_fm
    query_url = "http://transition.fcc.gov/fcc-bin/fmq?facid=#{facility_id}"
    puts "* Fetching #{query_url}"
    
    build_contour_fm_from_kml_url Nokogiri::HTML(open query_url).at("//a[starts-with(text(),'KML file')]")[:href]
  end
  
  def build_contour_fm_from_kml_url(url)
    contour_kml = get_contour_kml url

    query = %Q{
      update broadcasters
      set contour=ST_GeomFromKML(?)
      where id=#{id}
    }
    sanitized = ActiveRecord::Base.send :sanitize_sql_array, [query, contour_kml]
    ActiveRecord::Base.connection.execute sanitized
    
    reload
  end

  private

  def get_contour_kml(path)
    doc = Nokogiri::XML.parse(open path).remove_namespaces!
    line_string = doc.at "//Placemark[substring-after(name/text(), ' ')='dBu Service contour']/LineString"
    line_string.at('tessellate').remove
    line_string.at('altitudeMode').remove
    line_string.at('coordinates').content = line_string.at('coordinates').text.gsub(/,0 $/, '')
  
    return line_string.to_s
  end
  
end
