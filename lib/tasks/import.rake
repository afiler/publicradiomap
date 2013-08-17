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
    Dir['data/contours/*.kml'].each do |path|
      name = path.match /call=([^&]+)/ rescue next
      broadcaster = Broadcaster.find_by_callsign name
    end
  end
  
  task facilities: :environment do
    #CSV.open('data/fcc/facility.dat', :col_sep=>nil).each do |facility|
    #  Facility.create comm_city: facility[0], comm_state: facility[1], eeo_rpt_ind: facility[2], fac_address1: facility[3], fac_address2: facility[4], fac_callsign: facility[5], fac_channel: facility[6], fac_city: facility[7], fac_country: facility[8], fac_frequency: facility[9], fac_service: facility[10], fac_state: facility[11], fac_status_date: facility[12], fac_type: facility[13], facility_id: facility[14], lic_expiration_date: facility[15], fac_status: facility[16], fac_zip1: facility[17], fac_zip2: facility[18], station_type: facility[19], assoc_facility_id: facility[20], callsign_eff_date: facility[21], tsid_ntsc: facility[22], tsid_dtv: facility[23], digital_status: facility[24], sat_tv: facility[25], network_affil: facility[26], nielsen_dma: facility[27], tv_virtual_channel: facility[28], last_change_date: facility[29]
    #end
    #  copy facilities (comm_city, comm_state, eeo_rpt_ind, fac_address1, fac_address2, fac_callsign, fac_channel, fac_city, fac_country, fac_frequency, fac_service, fac_state, fac_status_date, fac_type, id, lic_expiration_date, fac_status, fac_zip1, fac_zip2, station_type, assoc_facility_id, callsign_eff_date, tsid_ntsc, tsid_dtv, digital_status, sat_tv, network_affil, nielsen_dma, tv_virtual_channel, last_change_date, crap1, crap2) from '/srv/www/publicradiomap/data/fcc/facility.dat' (format csv, delimiter '|', quote '$');
  end
  
  
end
