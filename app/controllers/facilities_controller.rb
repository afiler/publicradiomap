class FacilitiesController < ApplicationController
  before_action :set_facility, only: [:show, :edit, :update, :destroy]

  # GET /facilities
  # GET /facilities.json
  def index
    @facilities = Facility.all
  end

  # GET /facilities/1
  # GET /facilities/1.json
  def show
  end

  # GET /facilities/new
  def new
    @facility = Facility.new
  end

  # GET /facilities/1/edit
  def edit
  end

  # POST /facilities
  # POST /facilities.json
  def create
    return
    @facility = Facility.new(facility_params)

    respond_to do |format|
      if @facility.save
        format.html { redirect_to @facility, notice: 'Facility was successfully created.' }
        format.json { render action: 'show', status: :created, location: @facility }
      else
        format.html { render action: 'new' }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facilities/1
  # PATCH/PUT /facilities/1.json
  def update
    return
    respond_to do |format|
      if @facility.update(facility_params)
        format.html { redirect_to @facility, notice: 'Facility was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facilities/1
  # DELETE /facilities/1.json
  def destroy
    return
    @facility.destroy
    respond_to do |format|
      format.html { redirect_to facilities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facility
      @facility = Facility.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facility_params
      params.require(:facility).permit(:comm_city, :comm_state, :eeo_rpt_ind, :fac_address1, :fac_address2, :fac_callsign, :fac_channel, :fac_city, :fac_country, :fac_frequency, :fac_service, :fac_state, :fac_status_date, :fac_type, :facility_id, :lic_expiration_date, :fac_status, :fac_zip1, :fac_zip2, :station_type, :assoc_facility_id, :callsign_eff_date, :tsid_ntsc, :tsid_dtv, :digital_status, :sat_tv, :network_affil, :nielsen_dma, :tv_virtual_channel, :last_change_date)
    end
end
