class AddFacilityToBroadcaster < ActiveRecord::Migration
  def change
    add_reference :broadcasters, :facility, index: true
  end
end
