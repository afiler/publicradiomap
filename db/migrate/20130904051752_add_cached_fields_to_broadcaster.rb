class AddCachedFieldsToBroadcaster < ActiveRecord::Migration
  def change
    add_column :broadcasters, :contour_geojson, :text
  end
end
