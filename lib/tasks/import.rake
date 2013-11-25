require 'csv'

class NilClass
  def strip
    nil
  end
end

namespace :import do
  desc "TODO"
  
  task npr: :environment do
    open('data/npr_stations.txt').each do |line|
      case line
      when /^([A-Z ]+)$/
        @state = $1
      when /^(.+) ([A-Z0-9]+)-([AF]M) (.+)/
        data = {
          community: $1,
          official_state: @state,
          callsign: $2,
          band: $3,
          frequency: $4
        }
        
        broadcaster = Broadcaster.find_by_callsign $2
        if broadcaster
          data.delete :callsign
          broadcaster.update data
        else
          Broadcaster.create data
        end
        puts data
      else
        puts "Parse failed: #{line}"
      end
    end
  end
  
  task list: :environment do    
    lines = CSV.parse open('data/list.txt'), :col_sep=>"\t"
    network_list = lines.map { |line| line.first.strip }.sort.uniq
    networks = {}
    network_list.each do |network|
      networks[network] = Broadcaster.create name: network
      puts network
    end
    
    lines.each do |station|
      data = {
        parent: networks[station[0]],
        callsign: station[1].strip,
        retransmits: station[2].strip,
        frequency: station[3].strip,
        band: station[4].strip,
        community: station[5].strip,
      }
      puts data
      Broadcaster.create data
    end
  end

  task contours: :environment do
    require 'nokogiri'
    
    Dir['data/contours/*.kml'].each do |path|
      name = path.match /call=([^&]+)/ rescue next
      puts $1
      broadcaster = Broadcaster.find_by_callsign $1
      next unless broadcaster
      
      doc = Nokogiri::XML.parse(open path).remove_namespaces!
      line_string = doc.at "//Placemark[name/text()='60 dBu Service contour']/LineString"
      line_string.at('tessellate').remove
      line_string.at('altitudeMode').remove
      line_string.at('coordinates').content = line_string.at('coordinates').text.gsub(/,0 $/, '')
      
      query = %Q{
        update broadcasters
        set contour=ST_GeomFromKML(?)
        where id=#{broadcaster.id}
      }
      sanitized = ActiveRecord::Base.send :sanitize_sql_array, [query, line_string.to_s]
      ActiveRecord::Base.connection.execute sanitized
    end
  end
  
  task contours_from_web: :environment do
    require 'nokogiri'
    require 'open-uri'
    
    Broadcaster.find_by_sql("
      select * from broadcasters where band='FM' and contour is null and facility_id is not null and id > 2417
    ").each do |broadcaster|
      puts broadcaster.summary
      query_url = "http://transition.fcc.gov/fcc-bin/fmq?facid=#{broadcaster.facility_id}"
      puts query_url
      
      contour_kml = get_contour_kml Nokogiri::HTML(open query_url).at("//a[text()='KML file (60 dBu)']")[:href] rescue (puts "FAILED for #{broadcaster.summary}"; next)
      query = %Q{
        update broadcasters
        set contour=ST_GeomFromKML(?)
        where id=#{broadcaster.id}
      }
      sanitized = ActiveRecord::Base.send :sanitize_sql_array, [query, contour_kml]
      ActiveRecord::Base.connection.execute sanitized
    end
  end
  
  task contours_from_web: :environment do
    require 'nokogiri'
    require 'open-uri'
    
    Broadcaster.find_by_sql("
      select * from broadcasters where band='FM' and contour is null and facility_id is not null
    ").each do |broadcaster|
      puts broadcaster.summary
      query_url = "http://transition.fcc.gov/fcc-bin/fmq?facid=#{broadcaster.facility_id}"
      puts query_url
      
      contour_kml = get_contour_kml Nokogiri::HTML(open query_url).at("//a[text()='KML file (60 dBu)']")[:href] rescue (puts "FAILED for #{broadcaster.summary}"; next)
      query = %Q{
        update broadcasters
        set contour=ST_GeomFromKML(?)
        where id=#{broadcaster.id}
      }
      sanitized = ActiveRecord::Base.send :sanitize_sql_array, [query, contour_kml]
      ActiveRecord::Base.connection.execute sanitized
    end
  end

  def get_contour_kml(path)
    doc = Nokogiri::XML.parse(open path).remove_namespaces!
    line_string = doc.at "//Placemark[name/text()='60 dBu Service contour']/LineString"
    line_string.at('tessellate').remove
    line_string.at('altitudeMode').remove
    line_string.at('coordinates').content = line_string.at('coordinates').text.gsub(/,0 $/, '')
    
    return line_string.to_s
  end
  
  def insert_translators
    %Q{insert into broadcasters (notes, callsign, frequency, band, community, facility_id, parent_id)
    select 'auto_from_assoc' notes, fac_callsign, fac_frequency, fac_service, comm_city, id,
      (select id from broadcasters where facility_id=assoc_facility_id) broadcaster_id
    from facilities f
    where fac_status='LICEN' and fac_type in ('FT', 'FTB') and
    assoc_facility_id in (select f.id from facilities f join broadcasters b on b.facility_id = f.id) and
    id not in (select distinct facility_id from broadcasters where facility_id is not null);}
  end
  
  task facilities: :environment do
    #CSV.open('data/fcc/facility.dat', :col_sep=>nil).each do |facility|
    #  Facility.create comm_city: facility[0], comm_state: facility[1], eeo_rpt_ind: facility[2], fac_address1: facility[3], fac_address2: facility[4], fac_callsign: facility[5], fac_channel: facility[6], fac_city: facility[7], fac_country: facility[8], fac_frequency: facility[9], fac_service: facility[10], fac_state: facility[11], fac_status_date: facility[12], fac_type: facility[13], facility_id: facility[14], lic_expiration_date: facility[15], fac_status: facility[16], fac_zip1: facility[17], fac_zip2: facility[18], station_type: facility[19], assoc_facility_id: facility[20], callsign_eff_date: facility[21], tsid_ntsc: facility[22], tsid_dtv: facility[23], digital_status: facility[24], sat_tv: facility[25], network_affil: facility[26], nielsen_dma: facility[27], tv_virtual_channel: facility[28], last_change_date: facility[29]
    #end
    #  copy facilities (comm_city, comm_state, eeo_rpt_ind, fac_address1, fac_address2, fac_callsign, fac_channel, fac_city, fac_country, fac_frequency, fac_service, fac_state, fac_status_date, fac_type, id, lic_expiration_date, fac_status, fac_zip1, fac_zip2, station_type, assoc_facility_id, callsign_eff_date, tsid_ntsc, tsid_dtv, digital_status, sat_tv, network_affil, nielsen_dma, tv_virtual_channel, last_change_date, crap1, crap2) from '/srv/www/publicradiomap/data/fcc/facility.dat' (format csv, delimiter '|', quote '$');
  end
  
end
