class ImportSrcStations < ActiveRecord::Migration
  def tableize(t)
    t.search('tr').map do |tr|
      tr.xpath('tr|td').map do |td|
        ([td.text.strip] + td.search('a/@href').map { |x| x.to_s.strip }).join('|')
      end
    end
  end
  
  def change
    require 'rubygems'
    require 'nokogiri'
    require 'csv'
    require 'open-uri'

    url = 'http://en.wikipedia.org/wiki/Template:SRC_radio_stations'
    doc = Nokogiri::HTML.parse open(url)
    rc_links = doc.at("a[text()='Ici Radio-Canada Première']").parent.parent.children[2].search("ul/li/a").map { |a| a[:href] }
    rc_links.each do |link|
      puts link
      doc = Nokogiri::HTML.parse open("http://en.wikipedia.org#{link}")
      tables = doc.search('table')
      i = -1
      t = tables[i+=1]
      
      city_th = t.at("th/a[text()='City of license']")
      if not city_th
        t = tables[i+=1]
        city_th = t.at("th/a[text()='City of license']")
      end
      
      city = city_th.parent.next_sibling.next_sibling.text.split(',').first
      frequency_band = t.at("th/a[text()='Frequency']").parent.next_sibling.next_sibling.text
      frequency = frequency_band[/[\d\.]+/]
      band = frequency_band[/(?<=\()[^\)]+/]
      callsign = link.split('/').last[/[^_]+/]
      url = t.at("th[text()='Website']").next_sibling.next_sibling.at('a')['href']
       
      b = Broadcaster.create name: name, callsign: callsign, frequency: frequency, band: band, community: city, url: url
    
      t = tableize(tables[i+=1]) + tableize(tables[i+=1])
      
      t.reject { |x| x.length < 2 }.compact.each do |row|
        frequency, band = (row[2]||'').split(' ')
        band ||= 'FM'
        Broadcaster.create parent: b, callsign: row[1], frequency: frequency, band: band, community: row[0]
      end
      
      execute <<-SQL
        update broadcasters set contour=st_setsrid(wkb_geometry, 4326) from fmreg where fmreg.callsign=broadcasters.callsign and contour_value='500' and (broadcasters.callsign like 'C%' or broadcasters.callsign like 'V%') and contour is null;
        update broadcasters set contour=st_setsrid(wkb_geometry, 4326) from amreg where amreg.callsign=broadcasters.callsign and day_night <> 'NIGHT' and (broadcasters.callsign like 'C%' or broadcasters.callsign like 'V%') and contour is null;
      SQL
    end
  end
end
