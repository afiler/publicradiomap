class AddColorToBroadcasters < ActiveRecord::Migration
  def change
    add_column :broadcasters, :color, :string
  end
end
