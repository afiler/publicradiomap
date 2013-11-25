class CreateCbcStations < ActiveRecord::Migration
  class CbcStation < ActiveRecord::Base; end
  
  def change
    create_table :cbc_stations do |t|
      t.string :filename
      t.string :network
      t.string :callsign
      t.string :frequency
      t.string :band
    end
    
    reversible do |dir|
      dir.up do
        
        Dir['data/ca/cbc/index.php*'].each do |filename|
          puts filename
          begin
            results = JSON.parse(open(filename).read)['results'] or next
            results.each do |service|
              service['chanfreqs'].each do |chan|
                next unless chan['type']['name'] == 'Radio'
                frequency, band = chan['name'].split(/\s+/)
                puts CbcStation.create network: service['name'], callsign: chan['station'][/[^<]+/], frequency: frequency, band: band[/[AF]M/]
              end
            end
          rescue StandardError => e
            puts e
          end
        end
      end
    
      dir.down do
        execute <<-SQL
          truncate table cbc_stations
        SQL
      end
    end
  end  
  
end
