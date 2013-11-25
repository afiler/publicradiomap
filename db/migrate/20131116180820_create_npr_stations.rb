class CreateNprStations < ActiveRecord::Migration
  def change
    create_table :npr_stations do |t|
      t.json :station
    end
    
    reversible do |dir|
      dir.up do
        Dir['data/npr/stations.php*'].each do |filename|
          puts filename
          begin
            Array(Hash.from_xml(open(filename))["stations"]["station"]).each do |station|
              puts station['callLetters']
              execute <<-SQL
                insert into npr_stations (id, station)
                  select #{station['id']}, #{quote station.to_json}
                  where not exists (
                    select 1 from npr_stations where id=#{station['id']}
                  )
              SQL
            end
          rescue StandardError => e
            puts e
          end
        end
      end
    
      dir.down do
        execute <<-SQL
          truncate table npr_stations
        SQL
      end
    end
  end  
end
