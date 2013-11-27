class AddRadiusToBroadcasters < ActiveRecord::Migration
  def change
    add_column :broadcasters, :radius_in_km, :integer
  end
end
