require 'test_helper'

class FacilitiesControllerTest < ActionController::TestCase
  setup do
    @facility = facilities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:facilities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create facility" do
    assert_difference('Facility.count') do
      post :create, facility: { assoc_facility_id: @facility.assoc_facility_id, callsign_eff_date: @facility.callsign_eff_date, comm_city: @facility.comm_city, comm_state: @facility.comm_state, digital_status: @facility.digital_status, eeo_rpt_ind: @facility.eeo_rpt_ind, fac_address1: @facility.fac_address1, fac_address2: @facility.fac_address2, fac_callsign: @facility.fac_callsign, fac_channel: @facility.fac_channel, fac_city: @facility.fac_city, fac_country: @facility.fac_country, fac_frequency: @facility.fac_frequency, fac_service: @facility.fac_service, fac_state: @facility.fac_state, fac_status: @facility.fac_status, fac_status_date: @facility.fac_status_date, fac_type: @facility.fac_type, fac_zip1: @facility.fac_zip1, fac_zip2: @facility.fac_zip2, facility_id: @facility.facility_id, last_change_date: @facility.last_change_date, lic_expiration_date: @facility.lic_expiration_date, network_affil: @facility.network_affil, nielsen_dma: @facility.nielsen_dma, sat_tv: @facility.sat_tv, station_type: @facility.station_type, tsid_dtv: @facility.tsid_dtv, tsid_ntsc: @facility.tsid_ntsc, tv_virtual_channel: @facility.tv_virtual_channel }
    end

    assert_redirected_to facility_path(assigns(:facility))
  end

  test "should show facility" do
    get :show, id: @facility
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @facility
    assert_response :success
  end

  test "should update facility" do
    patch :update, id: @facility, facility: { assoc_facility_id: @facility.assoc_facility_id, callsign_eff_date: @facility.callsign_eff_date, comm_city: @facility.comm_city, comm_state: @facility.comm_state, digital_status: @facility.digital_status, eeo_rpt_ind: @facility.eeo_rpt_ind, fac_address1: @facility.fac_address1, fac_address2: @facility.fac_address2, fac_callsign: @facility.fac_callsign, fac_channel: @facility.fac_channel, fac_city: @facility.fac_city, fac_country: @facility.fac_country, fac_frequency: @facility.fac_frequency, fac_service: @facility.fac_service, fac_state: @facility.fac_state, fac_status: @facility.fac_status, fac_status_date: @facility.fac_status_date, fac_type: @facility.fac_type, fac_zip1: @facility.fac_zip1, fac_zip2: @facility.fac_zip2, facility_id: @facility.facility_id, last_change_date: @facility.last_change_date, lic_expiration_date: @facility.lic_expiration_date, network_affil: @facility.network_affil, nielsen_dma: @facility.nielsen_dma, sat_tv: @facility.sat_tv, station_type: @facility.station_type, tsid_dtv: @facility.tsid_dtv, tsid_ntsc: @facility.tsid_ntsc, tv_virtual_channel: @facility.tv_virtual_channel }
    assert_redirected_to facility_path(assigns(:facility))
  end

  test "should destroy facility" do
    assert_difference('Facility.count', -1) do
      delete :destroy, id: @facility
    end

    assert_redirected_to facilities_path
  end
end
