class AddNighttimePowerToBroadcaster < ActiveRecord::Migration
  def change
    add_column :broadcasters, :nighttime_power_in_watts, :integer
  end
end
