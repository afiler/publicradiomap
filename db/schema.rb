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

ActiveRecord::Schema.define(version: 20130904051752) do

  create_table "broadcasters", force: true do |t|
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
    t.spatial  "location",        limit: {:srid=>4326, :type=>"geometry"}
    t.spatial  "contour",         limit: {:srid=>4326, :type=>"geometry"}
    t.integer  "facility_id"
    t.string   "color"
    t.text     "contour_geojson"
  end

  add_index "broadcasters", ["facility_id"], :name => "index_broadcasters_on_facility_id"
  add_index "broadcasters", ["parent_id"], :name => "index_broadcasters_on_parent_id"

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

  add_index "facilities", ["fac_address1"], :name => "index_facilities_on_fac_address1"
  add_index "facilities", ["fac_address2"], :name => "index_facilities_on_fac_address2"
  add_index "facilities", ["fac_callsign"], :name => "index_facilities_on_fac_callsign"
  add_index "facilities", ["fac_city"], :name => "index_facilities_on_fac_city"
  add_index "facilities", ["fac_country"], :name => "index_facilities_on_fac_country"
  add_index "facilities", ["fac_state"], :name => "index_facilities_on_fac_state"

  create_table "facilities_parties", force: true do |t|
    t.integer  "facility_id"
    t.integer  "party_id"
    t.string   "party_type"
    t.datetime "last_change_date"
    t.string   "crap1"
    t.string   "crap2"
  end

  create_table "networks", force: true do |t|
    t.string  "fac_address1"
    t.string  "fac_address2"
    t.string  "fac_city"
    t.string  "fac_state"
    t.string  "fac_country"
    t.boolean "has_broadcaster"
  end

  add_index "networks", ["fac_address1"], :name => "index_networks_on_fac_address1"
  add_index "networks", ["fac_address2"], :name => "index_networks_on_fac_address2"
  add_index "networks", ["fac_city"], :name => "index_networks_on_fac_city"
  add_index "networks", ["fac_country"], :name => "index_networks_on_fac_country"
  add_index "networks", ["fac_state"], :name => "index_networks_on_fac_state"

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

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string "name"
  end

end
