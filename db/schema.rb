# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131127054852) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

# Could not dump table "amreg" because of following StandardError
#   Unknown type 'geometry(Geometry,900914)' for column 'wkb_geometry'

# Could not dump table "broadcasters" because of following StandardError
#   Unknown type 'geometry' for column 'location'

# Could not dump table "broadcasters_ext" because of following StandardError
#   Unknown type 'geometry' for column 'location'

  create_table "broadcasters_short", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "url"
    t.string   "callsign"
    t.string   "frequency"
    t.string   "band"
    t.integer  "power_in_watts"
    t.string   "retransmits"
    t.string   "community"
    t.string   "official_city"
    t.string   "official_state"
    t.integer  "parent_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "facility_id"
    t.string   "color"
    t.integer  "nighttime_power_in_watts"
    t.string   "subtitle"
  end

# Could not dump table "ca_facilities" because of following StandardError
#   Unknown type 'unknown' for column 'band'

# Could not dump table "ca_facilities_am" because of following StandardError
#   Unknown type 'geometry' for column 'wkb_geometry'

# Could not dump table "ca_facilities_fm" because of following StandardError
#   Unknown type 'geometry' for column 'wkb_geometry'

  create_table "cbc_stations", force: true do |t|
    t.string "filename"
    t.string "network"
    t.string "callsign"
    t.string "frequency"
    t.string "band"
  end

  create_table "facilities", force: true do |t|
    t.string   "comm_city"
    t.string   "comm_state"
    t.string   "eeo_rpt_ind"
    t.string   "fac_address1"
    t.string   "fac_address2"
    t.string   "fac_callsign"
    t.integer  "fac_channel"
    t.string   "fac_city"
    t.string   "fac_country"
    t.float    "fac_frequency"
    t.string   "fac_service"
    t.string   "fac_state"
    t.datetime "fac_status_date"
    t.string   "fac_type"
    t.integer  "facility_id"
    t.datetime "lic_expiration_date"
    t.string   "fac_status"
    t.string   "fac_zip1"
    t.string   "fac_zip2"
    t.string   "station_type"
    t.integer  "assoc_facility_id"
    t.datetime "callsign_eff_date"
    t.integer  "tsid_ntsc"
    t.integer  "tsid_dtv"
    t.string   "digital_status"
    t.string   "sat_tv"
    t.string   "network_affil"
    t.string   "nielsen_dma"
    t.integer  "tv_virtual_channel"
    t.datetime "last_change_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crap1"
    t.string   "crap2"
    t.string   "crap3"
    t.integer  "network_id"
  end

  add_index "facilities", ["fac_address1"], name: "index_facilities_on_fac_address1", using: :btree
  add_index "facilities", ["fac_address2"], name: "index_facilities_on_fac_address2", using: :btree
  add_index "facilities", ["fac_callsign"], name: "index_facilities_on_fac_callsign", using: :btree
  add_index "facilities", ["fac_city"], name: "index_facilities_on_fac_city", using: :btree
  add_index "facilities", ["fac_country"], name: "index_facilities_on_fac_country", using: :btree
  add_index "facilities", ["fac_state"], name: "index_facilities_on_fac_state", using: :btree

  create_table "facilities_parties", force: true do |t|
    t.integer  "facility_id"
    t.integer  "party_id"
    t.string   "party_type"
    t.datetime "last_change_date"
    t.string   "crap1"
    t.string   "crap2"
  end

  create_table "fcc_am_ant_sys", force: true do |t|
    t.string   "ant_mode"
    t.integer  "ant_sys_id"
    t.integer  "application_id"
    t.integer  "aug_count"
    t.string   "bad_data_switch"
    t.string   "domestic_pattern"
    t.string   "dummy_data_switch"
    t.float    "efficiency_restricted"
    t.float    "efficiency_theoretical"
    t.string   "feed_circ_other"
    t.string   "feed_circ_type"
    t.string   "hours_operation"
    t.integer  "lat_deg"
    t.string   "lat_dir"
    t.integer  "lat_min"
    t.float    "lat_sec"
    t.integer  "lon_deg"
    t.string   "lon_dir"
    t.integer  "lon_min"
    t.float    "lon_sec"
    t.float    "q_factor"
    t.string   "q_factor_custom_ind"
    t.float    "power"
    t.float    "rms_augmented"
    t.float    "rms_standard"
    t.float    "rms_theoretical"
    t.integer  "tower_count"
    t.string   "eng_record_type"
    t.float    "biased_lat"
    t.float    "biased_long"
    t.string   "mainkey"
    t.string   "am_dom_status"
    t.integer  "lat_whole_secs"
    t.integer  "lon_whole_secs"
    t.string   "ant_dir_ind"
    t.string   "grandfathered_ind"
    t.string   "specified_hrs_range"
    t.string   "augmented_ind"
    t.datetime "last_update_date"
    t.string   "crap1"
    t.string   "crap2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fcc_am_eng_data", force: true do |t|
    t.string   "ant_monitor"
    t.integer  "application_id"
    t.string   "broadcast_schedule"
    t.float    "encl_fence_dist"
    t.integer  "facility_id"
    t.string   "sampl_sys_ind"
    t.string   "station_class"
    t.string   "time_zone"
    t.string   "region_2_class"
    t.string   "am_dom_status"
    t.string   "old_station_class"
    t.string   "specified_hours"
    t.string   "feed_circ_other"
    t.string   "feed_circ_type"
    t.datetime "last_update_date"
    t.string   "crap1"
    t.string   "crap2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fcc_applications", force: true do |t|
    t.string   "app_arn"
    t.string   "app_service"
    t.integer  "facility_id"
    t.string   "file_prefix"
    t.string   "comm_city"
    t.string   "comm_state"
    t.float    "fac_frequency"
    t.integer  "station_channel"
    t.string   "fac_callsign"
    t.string   "general_app_service"
    t.string   "app_type"
    t.string   "paper_filed_ind"
    t.string   "dtv_type"
    t.string   "frn"
    t.string   "shortform_app_arn"
    t.string   "shortform_file_prefix"
    t.string   "corresp_ind"
    t.integer  "assoc_facility_id"
    t.string   "network_affil"
    t.string   "sat_tv_ind"
    t.string   "comm_county"
    t.string   "comm_zip1"
    t.string   "comm_zip2"
    t.datetime "last_change_date"
    t.string   "crap1"
    t.string   "crap2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fcc_fm_eng_data", force: true do |t|
    t.float    "ant_input_pwr"
    t.float    "ant_max_pwr_gain"
    t.string   "ant_polarization"
    t.float    "ant_rotation"
    t.integer  "antenna_id"
    t.string   "antenna_type"
    t.integer  "application_id"
    t.string   "asd_service"
    t.string   "asrn_na_ind"
    t.integer  "asrn"
    t.float    "avg_horiz_pwr_gain"
    t.float    "biased_lat"
    t.float    "biased_long"
    t.string   "border_code"
    t.float    "border_dist"
    t.string   "docket_num"
    t.float    "effective_erp"
    t.float    "elev_amsl"
    t.float    "elev_bldg_ag"
    t.string   "eng_record_type"
    t.integer  "facility_id"
    t.string   "fm_dom_status"
    t.float    "gain_area"
    t.float    "haat_horiz_rc_mtr"
    t.float    "haat_vert_rc_mtr"
    t.float    "hag_horiz_rc_mtr"
    t.float    "hag_overall_mtr"
    t.float    "hag_vert_rc_mtr"
    t.float    "horiz_bt_erp"
    t.float    "horiz_erp"
    t.integer  "lat_deg"
    t.string   "lat_dir"
    t.integer  "lat_min"
    t.float    "lat_sec"
    t.integer  "lon_deg"
    t.string   "lon_dir"
    t.integer  "lon_min"
    t.float    "lon_sec"
    t.float    "loss_area"
    t.float    "max_ant_pwr_gain"
    t.float    "max_haat"
    t.float    "max_horiz_erp"
    t.float    "max_vert_erp"
    t.float    "multiplexor_loss"
    t.float    "power_output_vis_kw"
    t.float    "predict_coverage_area"
    t.integer  "predict_pop"
    t.float    "rcamsl_horiz_mtr"
    t.float    "rcamsl_vert_mtr"
    t.string   "station_class"
    t.string   "terrain_data_src"
    t.float    "vert_bt_erp"
    t.float    "vert_erp"
    t.integer  "num_sections"
    t.float    "present_area"
    t.float    "percent_change"
    t.float    "spacing"
    t.string   "terrain_data_src_other"
    t.float    "trans_power_output"
    t.string   "mainkey"
    t.integer  "lat_whole_secs"
    t.integer  "lon_whole_secs"
    t.integer  "station_channel"
    t.string   "lic_ant_make"
    t.string   "lic_ant_model_num"
    t.float    "min_horiz_erp"
    t.string   "haat_horiz_calc_ind"
    t.integer  "erp_w"
    t.integer  "trans_power_output_w"
    t.string   "market_group_num"
    t.datetime "last_change_date"
    t.string   "crap1"
    t.string   "crap2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "fmreg" because of following StandardError
#   Unknown type 'geometry(Geometry,900914)' for column 'wkb_geometry'

  create_table "layer", id: false, force: true do |t|
    t.integer "topology_id",                            null: false
    t.integer "layer_id",                               null: false
    t.string  "schema_name",    limit: nil,             null: false
    t.string  "table_name",     limit: nil,             null: false
    t.string  "feature_column", limit: nil,             null: false
    t.integer "feature_type",                           null: false
    t.integer "level",                      default: 0, null: false
    t.integer "child_id"
  end

  add_index "layer", ["schema_name", "table_name", "feature_column"], name: "layer_schema_name_table_name_feature_column_key", unique: true, using: :btree

  create_table "networks", force: true do |t|
    t.string  "fac_address1"
    t.string  "fac_address2"
    t.string  "fac_city"
    t.string  "fac_state"
    t.string  "fac_country"
    t.boolean "has_broadcaster"
  end

  add_index "networks", ["fac_address1"], name: "index_networks_on_fac_address1", using: :btree
  add_index "networks", ["fac_address2"], name: "index_networks_on_fac_address2", using: :btree
  add_index "networks", ["fac_city"], name: "index_networks_on_fac_city", using: :btree
  add_index "networks", ["fac_country"], name: "index_networks_on_fac_country", using: :btree
  add_index "networks", ["fac_state"], name: "index_networks_on_fac_state", using: :btree

  create_table "npr_stations", force: true do |t|
    t.json "station"
  end

  create_table "parties", force: true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "citizenship"
    t.string   "city"
    t.string   "company"
    t.string   "country"
    t.string   "email"
    t.string   "fax"
    t.string   "legal_name"
    t.string   "name"
    t.string   "phone"
    t.string   "state"
    t.string   "zip1"
    t.string   "zip2"
    t.datetime "last_change_date"
    t.string   "crap1"
    t.string   "crap2"
  end

  create_table "spatial_ref_sys", id: false, force: true do |t|
    t.integer "srid",                   null: false
    t.string  "auth_name", limit: 256
    t.integer "auth_srid"
    t.string  "srtext",    limit: 2048
    t.string  "proj4text", limit: 2048
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "tmp_npr", id: false, force: true do |t|
    t.integer "id"
    t.text    "callletters"
    t.text    "band"
    t.text    "name"
    t.text    "network"
    t.text    "frequency"
    t.text    "marketcity"
    t.text    "state"
  end

  create_table "tmp_npr_2", id: false, force: true do |t|
    t.integer "id"
    t.text    "callletters"
    t.text    "band"
    t.text    "name"
    t.text    "network"
    t.text    "frequency"
    t.text    "marketcity"
    t.text    "state"
  end

  create_table "topology", force: true do |t|
    t.string  "name",      limit: nil,                 null: false
    t.integer "srid",                                  null: false
    t.float   "precision",                             null: false
    t.boolean "hasz",                  default: false, null: false
  end

  add_index "topology", ["name"], name: "topology_name_key", unique: true, using: :btree

end
