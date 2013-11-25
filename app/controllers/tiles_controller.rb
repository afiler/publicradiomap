class TilesController < ApplicationController
  def show
    #return head :forbidden if (params[:zoom].to_i < 10)
    
    #render text: Tile.find_by_bbox(params[:x].to_i, params[:y].to_i, params[:zoom].to_i)
    @broadcasters = Tile.find_by_bboxx(params[:x].to_i, params[:y].to_i, params[:zoom].to_i)
  end
  
  private
  
  def tile_to_bbox(x, y, zoom)
    n = 2.0 ** zoom
    lon_deg  =  x    / n * 360.0 - 180.0
    lon2_deg = (x+1) / n * 360.0 - 180.0
    lat_rad  = Math::atan(Math::sinh(Math::PI * (1 - 2 *  y    / n)))
    lat2_rad = Math::atan(Math::sinh(Math::PI * (1 - 2 * (y+1) / n)))
    lat_deg  = lat_rad * 180.0 / Math::PI
    lat2_deg = lat2_rad * 180.0 / Math::PI
    return {
      :west  => lat_deg,
      :north => lon_deg,
      :east  => lat2_deg,
      :south => lon2_deg
    }
  end
  
  
end