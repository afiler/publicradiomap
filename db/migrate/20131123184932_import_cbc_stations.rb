$names = {'CBR'=>'Calgary', 'CBCT'=>'Charlottetown', 'CBY'=>'Corner Brook', 'CBX'=>'Edmonton', 'CBZF'=>'Fredericton', 'CBG'=>'Gander', 'CFGB'=>'Goose Bay', 'CBT'=>'Grand Falls', 'CBHA'=>'Halifax', 'CHAK'=>'Inuvik', 'CFFB'=>'Iqaluit', 'CBYK'=>'Kamloops', 'CBTK'=>'Kelowna', 'CBKA'=>'La Ronge', 'CBDQ'=>'Labrador City', 'CBCL'=>'London', 'CBAM'=>'Moncton', 'CBME'=>'Montreal', 'CBO'=>'Ottawa', 'CBLA-2'=>'Kitchener/Waterloo', 'CBYG'=>'Prince George', 'CFPR'=>'Prince Rupert', 'CBVE'=>'Quebec City', 'CBQR'=>'Rankin Inlet', 'CBD'=>'Saint John', 'CBN'=>'St. John\'s', 'CBCS'=>'Sudbury', 'CBI'=>'Sydney', 'CBWK'=>'Thompson', 'CBQT'=>'Thunder Bay', 'CBLA'=>'Toronto', 'CBU'=>'Vancouver', 'CBCV'=>'Victoria', 'CBK'=>'Saskatchewan', 'CFWH'=>'Whitehorse', 'CBEW'=>'Windsor', 'CBW'=>'Winnipeg', 'CFYK'=>'Yellowknife'}

class ImportCbcStations < ActiveRecord::Migration
  def change
    require 'rubygems'
    require 'nokogiri'
    require 'csv'
    

    def import_file(f)
      tables = Nokogiri::HTML.parse(open(f)).search('table').map { |t| tableize(t) }
      callsign = f.split('/').last[/[^_]+/]
      city = tables[0][2][0].split('|').first
      frequency_band = tables[0][4][0].split('|').first
      frequency = frequency_band[/[\d\.]+/]
      band = frequency_band[/(?<=\()[^\)]+/]
      name = "CBC R1 #{$names[callsign[/[^-]+/]]}"
      puts name
      url = tables.first.last.first.split('|').last
      
      b = Broadcaster.create name: name, callsign: callsign, frequency: frequency, band: band, community: city, url: url
      
      (tables[1]+tables[2]).reject { |x| x.length < 2 }.compact.each do |row|
        frequency, band = (row[2]||'').split(' ')
        band ||= 'FM'
        Broadcaster.create parent: b, callsign: row[1], frequency: frequency, band: band, community: row[0]
      end
    end

    def tableize(t)
      t.search('tr').map do |tr|
        tr.xpath('tr|td').map do |td|
          ([td.text.strip] + td.search('a/@href').map { |x| x.to_s.strip }).join('|')
        end
      end
    end

    Dir['data/ca/wikipedia/C*'].each { |f| import_file(f) }
    
    more = [
      ['CBI',[
        ['CBIB-FM','Bay St. Lawrence','90.1','FM'],
        ['CBIC-FM','Cheticamp','107.1','FM'],
        ['CBHF-FM','Northeast Margaree','93.9','FM'],
        ['CBHI-FM','Inverness','94.3','FM'],
      ]],
      ['CBW', [
        ['CBW-1-FM','Winnipeg','89.3','FM'],
        ['CBWV-FM','Brandon','97.9','FM'],
        ['CBWW-FM','Dauphin-Baldy Mountain','105.3','FM'],
        ['CBWX-FM','Fisher Branch','95.7','FM'],
        ['CBWA-FM','Manigotagan','101.3','FM'],
        ['CBWY-FM','Jackhead','92.7','FM'],
        ['CBWZ-FM','Fairford','104.3','FM'],
      ]],
      ['CFFB', [
        ['CFFB-1-FM','Cambridge Bay','101.9','FM'],
        ['CFFB-2-FM','Kugluktuk','101.9','FM'],
        ['CBIH-FM','Cape Dorset','105.1','FM'],
        ['CBII-FM','Igloolik','105.1','FM'],
        ['CBIJ-FM','Pangnirtung','105.1','FM'],
        ['CBIK-FM','Pond Inlet','105.1','FM'],
        ['CBIL-FM','Resolute','105.1','FM'],
        ['VF2402','Kattiniq, Quebec','93.5 ','FM'],
        ['CKAB-FM','Arctic Bay','107.1','FM'],
        ['CKQN-FM','Baker Lake','99.3','FM'],
        ['CFCI-FM','Chesterfield Inlet','107.1','FM'],
        ['CJCR-FM','Clyde River','107.1','FM'],
        ['CJZS-FM','Coral Harbour','107.1','FM'],
        ['CFGF-FM','Grise Fiord','107.1','FM'],
        ['CFPB-FM','Kugaaruk','107.1','FM'],
        ['VF2046','Repulse Bay','107.1','FM'],
        ['CKSN-FM','Sanikiluaq','106.1','FM'],
        ['CKWC-FM','Whale Cove','106.1','FM'],
      ]],
    ]
    
    more.each do |parent_callsign, stations|
      parent = Broadcaster.find_by_callsign parent_callsign
      stations.each do |callsign, community, frequency, band|
        Broadcaster.create parent: parent, callsign: callsign, community: community, frequency: frequency, band: band
      end
    end
    
    execute <<-SQL
      update broadcasters set contour=st_setsrid(wkb_geometry, 4326) from fmreg where fmreg.callsign=broadcasters.callsign and contour_value='500' and (broadcasters.callsign like 'C%' or broadcasters.callsign like 'V%') and contour is null;
      update broadcasters set contour=st_setsrid(wkb_geometry, 4326) from amreg where amreg.callsign=broadcasters.callsign and day_night <> 'NIGHT' and (broadcasters.callsign like 'C%' or broadcasters.callsign like 'V%') and contour is null;
    SQL
  end
end
