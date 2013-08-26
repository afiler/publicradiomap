class CreateBroadcasters < ActiveRecord::Migration
  def change
    create_table :broadcasters do |t|
      t.string :name
      t.string :url
      t.string :callsign
      t.string :frequency
      t.string :band
      t.integer :power_in_watts
      t.string :retransmits
      t.string :community
      t.string :official_city
      t.string :official_state
      t.references :parent, index: true
      t.text :notes
      
      t.geometry :location
      t.geometry :contour

      t.timestamps
    end
    
    # SELECT UpdateGeometrySRID('broadcasters', 'contour', 4326);
    # SELECT UpdateGeometrySRID('broadcasters', 'location', 4326);
  end
end
