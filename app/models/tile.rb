class Tile
  class << self
    
    def find_by_bbox(x, y, zoom)
      factory = ::RGeo::Cartesian.preferred_factory
      
      bbox = tile_to_bbox(x, y, zoom)#, expand: true)
      
      #bbox = RGeo::Cartesian::BoundingBox.create_from_points(factory.point(x1, y1), factory.point(x2, y2))
      #@broadcasters = Broadcaster.where { contour.op '&&', bbox }.all
      
      # query = ActiveRecord::Base.send :sanitize_sql_array, [%Q{
             #   select id, callsign, frequency,
             #   st_asgeojson(st_intersection(contour, st_setsrid(st_makebox2d(st_makepoint(?, ?), st_makepoint(?, ?)), 4326)), 6) as geom
             #   from broadcasters
             #   where contour && st_transform(ST_SetSRID(ST_MakeBox2D(ST_MakePoint(?, ?), ST_MakePoint(?, ?)), 4326), 4326)
             # }, crop[:south], crop[:west], crop[:north], crop[:east], bbox[:south], bbox[:west], bbox[:north], bbox[:east]]
      query = ActiveRecord::Base.send :sanitize_sql_array, [%Q{
         select id, callsign, frequency,
         st_asgeojson(contour, 6) as geom
         from broadcasters
         where ST_Intersects(contour, st_transform(ST_SetSRID(ST_MakeBox2D(ST_MakePoint(?, ?), ST_MakePoint(?, ?)), 4326), 4326))
       }, bbox[:south], bbox[:west], bbox[:north], bbox[:east]]      
      
      JSON type: "FeatureCollection",
           features: ActiveRecord::Base.connection.execute(query).map { |row|
             {
               id: row['id'],
               type: "Feature",
               properties: { callsign: row['callsign'], frequency: row['frequency'] },
               geometry: JSON.parse(row['geom'])
             }
           }
    end
    
    def find_by_bboxx(x, y, zoom)
      bbox = tile_to_bbox(x, y, zoom)#, expand: true)
      Broadcaster.where "ST_Intersects(contour, st_transform(ST_SetSRID(ST_MakeBox2D(ST_MakePoint(:south, :west), ST_MakePoint(:north, :east)), 4326), 4326))", bbox
    end
    
    def tile_to_bbox(x, y, zoom)
      n = 2.0 ** zoom
      lon_deg  =  x    / n * 360.0 - 180.0
      lon2_deg = (x+1) / n * 360.0 - 180.0
      lat_rad  = Math::atan(Math::sinh(Math::PI * (1 - 2 *  y    / n)))
      lat2_rad = Math::atan(Math::sinh(Math::PI * (1 - 2 * (y+1) / n)))
      lat_deg  = lat_rad * 180.0 / Math::PI
      lat2_deg = lat2_rad * 180.0 / Math::PI

      {
          :west  => lat_deg,
          :north => lon_deg,
          :east  => lat2_deg,
          :south => lon2_deg
      }
    end
  
    # grow the tile bbox by 4 "pixels" in each direction, assuming it's
    # 256 pixels wide
    def expand_bbox(bbox)
      
      # if expand
     #    w = (lat2_deg - lat_deg).abs * (4.0/256)
     #    h = (lon_deg - lon2_deg).abs * (4.0/256)
     #    lat_deg += w
     #    lon_deg -= h
     #    lat2_deg -= w
     #    lon2_deg += h
     #  end
      
      w = (bbox[:east] - bbox[:west]).abs * (4.0/256)
      h = (bbox[:north] - bbox[:south]).abs * (4.0/256)
      bbox[:west] += w
      bbox[:east] -= w
      bbox[:north] -= h
      bbox[:south] += h
      return bbox
    end
  end
end
