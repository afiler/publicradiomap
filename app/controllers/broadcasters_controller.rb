class BroadcastersController < ApplicationController
  before_action :set_broadcaster, only: [:show, :edit, :update, :destroy]

  # GET /broadcasters
  # GET /broadcasters.json
  def index
    @broadcasters = Broadcaster.all
  end

  # GET /broadcasters/1
  # GET /broadcasters/1.json
  def show
  end

  # GET /broadcasters/new
  def new
    @broadcaster = Broadcaster.new
  end

  # GET /broadcasters/1/edit
  def edit
  end

  # POST /broadcasters
  # POST /broadcasters.json
  def create
    @broadcaster = Broadcaster.new(broadcaster_params)

    respond_to do |format|
      if @broadcaster.save
        format.html { redirect_to @broadcaster, notice: 'Broadcaster was successfully created.' }
        format.json { render action: 'show', status: :created, location: @broadcaster }
      else
        format.html { render action: 'new' }
        format.json { render json: @broadcaster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /broadcasters/1
  # PATCH/PUT /broadcasters/1.json
  def update
    respond_to do |format|
      if @broadcaster.update(broadcaster_params)
        format.html { redirect_to @broadcaster, notice: 'Broadcaster was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @broadcaster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /broadcasters/1
  # DELETE /broadcasters/1.json
  def destroy
    @broadcaster.destroy
    respond_to do |format|
      format.html { redirect_to broadcasters_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_broadcaster
      @broadcaster = Broadcaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def broadcaster_params
      params[:broadcaster]
    end
end
