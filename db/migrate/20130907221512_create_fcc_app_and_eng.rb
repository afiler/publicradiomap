class CreateFccAppAndEng < ActiveRecord::Migration
  def change
    create_table :fcc_applications do |t|
      t.string :app_arn
      t.string :app_service
      t.integer :facility_id
      t.string :file_prefix
      t.string :comm_city
      t.string :comm_state
      t.float :fac_frequency
      t.integer :station_channel
      t.string :fac_callsign
      t.string :general_app_service
      t.string :app_type
      t.string :paper_filed_ind
      t.string :dtv_type
      t.string :frn
      t.string :shortform_app_arn
      t.string :shortform_file_prefix
      t.string :corresp_ind
      t.integer :assoc_facility_id
      t.string :network_affil
      t.string :sat_tv_ind
      t.string :comm_county
      t.string :comm_zip1
      t.string :comm_zip2
      t.datetime :last_change_date
      
      t.string :crap1
      t.string :crap2
      t.timestamps
    end
    
    create_table :fcc_am_ant_sys do |t|
      t.string :ant_mode
      t.integer :ant_sys_id
      t.integer :application_id
      t.integer :aug_count
      t.string :bad_data_switch
      t.string :domestic_pattern
      t.string :dummy_data_switch
      t.float :efficiency_restricted
      t.float :efficiency_theoretical
      t.string :feed_circ_other
      t.string :feed_circ_type
      t.string :hours_operation
      t.integer :lat_deg
      t.string :lat_dir
      t.integer :lat_min
      t.float :lat_sec
      t.integer :lon_deg
      t.string :lon_dir
      t.integer :lon_min
      t.float :lon_sec
      t.float :q_factor
      t.string :q_factor_custom_ind
      t.float :power
      t.float :rms_augmented
      t.float :rms_standard
      t.float :rms_theoretical
      t.integer :tower_count
      t.string :eng_record_type
      t.float :biased_lat
      t.float :biased_long
      t.string :mainkey
      t.string :am_dom_status
      t.integer :lat_whole_secs
      t.integer :lon_whole_secs
      t.string :ant_dir_ind
      t.string :grandfathered_ind
      t.string :specified_hrs_range
      t.string :augmented_ind
      t.datetime :last_update_date
      
      t.string :crap1
      t.string :crap2
      t.timestamps
    end
    
    create_table :fcc_am_eng_data do |t|
      t.string :ant_monitor
      t.integer :application_id
      t.string :broadcast_schedule
      t.float :encl_fence_dist
      t.integer :facility_id
      t.string :sampl_sys_ind
      t.string :station_class
      t.string :time_zone
      t.string :region_2_class
      t.string :am_dom_status
      t.string :old_station_class
      t.string :specified_hours
      t.string :feed_circ_other
      t.string :feed_circ_type
      t.datetime :last_update_date
      
      t.string :crap1
      t.string :crap2
      t.timestamps
    end
    
    create_table :fcc_fm_eng_data do |t|
      t.float :ant_input_pwr
      t.float :ant_max_pwr_gain
      t.string :ant_polarization
      t.float :ant_rotation
      t.integer :antenna_id
      t.string :antenna_type
      t.integer :application_id
      t.string :asd_service
      t.string :asrn_na_ind
      t.integer :asrn
      t.float :avg_horiz_pwr_gain
      t.float :biased_lat
      t.float :biased_long
      t.string :border_code
      t.float :border_dist
      t.string :docket_num
      t.float :effective_erp
      t.float :elev_amsl
      t.float :elev_bldg_ag
      t.string :eng_record_type
      t.integer :facility_id
      t.string :fm_dom_status
      t.float :gain_area
      t.float :haat_horiz_rc_mtr
      t.float :haat_vert_rc_mtr
      t.float :hag_horiz_rc_mtr
      t.float :hag_overall_mtr
      t.float :hag_vert_rc_mtr
      t.float :horiz_bt_erp
      t.float :horiz_erp
      t.integer :lat_deg
      t.string :lat_dir
      t.integer :lat_min
      t.float :lat_sec
      t.integer :lon_deg
      t.string :lon_dir
      t.integer :lon_min
      t.float :lon_sec
      t.float :loss_area
      t.float :max_ant_pwr_gain
      t.float :max_haat
      t.float :max_horiz_erp
      t.float :max_vert_erp
      t.float :multiplexor_loss
      t.float :power_output_vis_kw
      t.float :predict_coverage_area
      t.integer :predict_pop
      t.float :rcamsl_horiz_mtr
      t.float :rcamsl_vert_mtr
      t.string :station_class
      t.string :terrain_data_src
      t.float :vert_bt_erp
      t.float :vert_erp
      t.integer :num_sections
      t.float :present_area
      t.float :percent_change
      t.float :spacing
      t.string :terrain_data_src_other
      t.float :trans_power_output
      t.string :mainkey
      t.integer :lat_whole_secs
      t.integer :lon_whole_secs
      t.integer :station_channel
      t.string :lic_ant_make
      t.string :lic_ant_model_num
      t.float :min_horiz_erp
      t.string :haat_horiz_calc_ind
      t.integer :erp_w
      t.integer :trans_power_output_w
      t.string :market_group_num
      t.datetime :last_change_date
      
      t.string :crap1
      t.string :crap2
      t.timestamps
    end
    
    execute "
      copy fcc_applications (app_arn, app_service, id, facility_id, file_prefix, comm_city, comm_state, fac_frequency, station_channel, fac_callsign, general_app_service, app_type, paper_filed_ind, dtv_type, frn, shortform_app_arn, shortform_file_prefix, corresp_ind, assoc_facility_id, network_affil, sat_tv_ind, comm_county, comm_zip1, comm_zip2, last_change_date, crap1, crap2)
      from '/srv/www/publicradiomap/data/fcc/application.dat' (format csv, delimiter '|', quote '\t');
      
      copy fcc_am_ant_sys (ant_mode, ant_sys_id, application_id, aug_count, bad_data_switch, domestic_pattern, dummy_data_switch, efficiency_restricted, efficiency_theoretical, feed_circ_other, feed_circ_type, hours_operation, lat_deg, lat_dir, lat_min, lat_sec, lon_deg, lon_dir, lon_min, lon_sec, q_factor, q_factor_custom_ind, power, rms_augmented, rms_standard, rms_theoretical, tower_count, eng_record_type, biased_lat, biased_long, mainkey, am_dom_status, lat_whole_secs, lon_whole_secs, ant_dir_ind, grandfathered_ind, specified_hrs_range, augmented_ind, last_update_date, crap1, crap2)
      from '/srv/www/publicradiomap/data/fcc/am_ant_sys.dat' (format csv, delimiter '|', quote '\t');

      copy fcc_am_eng_data (ant_monitor, application_id, broadcast_schedule, encl_fence_dist, facility_id, sampl_sys_ind, station_class, time_zone, region_2_class, am_dom_status, old_station_class, specified_hours, feed_circ_other, feed_circ_type, last_update_date, crap1, crap2)
      from '/srv/www/publicradiomap/data/fcc/am_eng_data.dat' (format csv, delimiter '|', quote '\t');
      
      copy fcc_fm_eng_data (ant_input_pwr, ant_max_pwr_gain, ant_polarization, ant_rotation, antenna_id, antenna_type, application_id, asd_service, asrn_na_ind, asrn, avg_horiz_pwr_gain, biased_lat, biased_long, border_code, border_dist, docket_num, effective_erp, elev_amsl, elev_bldg_ag, eng_record_type, facility_id, fm_dom_status, gain_area, haat_horiz_rc_mtr, haat_vert_rc_mtr, hag_horiz_rc_mtr, hag_overall_mtr, hag_vert_rc_mtr, horiz_bt_erp, horiz_erp, lat_deg, lat_dir, lat_min, lat_sec, lon_deg, lon_dir, lon_min, lon_sec, loss_area, max_ant_pwr_gain, max_haat, max_horiz_erp, max_vert_erp, multiplexor_loss, power_output_vis_kw, predict_coverage_area, predict_pop, rcamsl_horiz_mtr, rcamsl_vert_mtr, station_class, terrain_data_src, vert_bt_erp, vert_erp, num_sections, present_area, percent_change, spacing, terrain_data_src_other, trans_power_output, mainkey, lat_whole_secs, lon_whole_secs, station_channel, lic_ant_make, lic_ant_model_num, min_horiz_erp, haat_horiz_calc_ind, erp_w, trans_power_output_w, market_group_num, last_change_date, crap1, crap2)
      from '/srv/www/publicradiomap/data/fcc/fm_eng_data.dat' (format csv, delimiter '|', quote '\t');
      
      update broadcasters set power_in_watts=power*1000 from fcc_applications, fcc_am_ant_sys  where broadcasters.facility_id=fcc_applications.facility_id and fcc_am_ant_sys.application_id=fcc_applications.id and band='AM' and eng_record_type='C' and hours_operation in ('D','U');
      
      update broadcasters set nighttime_power_in_watts=power*1000 from fcc_applications, fcc_am_ant_sys  where broadcasters.facility_id=fcc_applications.facility_id and fcc_am_ant_sys.application_id=fcc_applications.id and band='AM' and eng_record_type='C' and hours_operation='N';
    "
    
    #base_watts = 5000
    #base_radius_km = 200
    #factor = (1.0*a_watts/base_watts)**0.5
    
  end
end
