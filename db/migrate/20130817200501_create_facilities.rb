class CreateFacilities < ActiveRecord::Migration
  def change
    create_table :facilities do |t|
      t.string :comm_city
      t.string :comm_state
      t.string :eeo_rpt_ind
      t.string :fac_address1
      t.string :fac_address2
      t.string :fac_callsign
      t.integer :fac_channel
      t.string :fac_city
      t.string :fac_country
      t.float :fac_frequency
      t.string :fac_service
      t.string :fac_state
      t.datetime :fac_status_date
      t.string :fac_type
      t.integer :facility_id
      t.datetime :lic_expiration_date
      t.string :fac_status
      t.string :fac_zip1
      t.string :fac_zip2
      t.string :station_type
      t.integer :assoc_facility_id
      t.datetime :callsign_eff_date
      t.integer :tsid_ntsc
      t.integer :tsid_dtv
      t.string :digital_status
      t.string :sat_tv
      t.string :network_affil
      t.string :nielsen_dma
      t.integer :tv_virtual_channel
      t.datetime :last_change_date

      t.timestamps
    end
  end
end
