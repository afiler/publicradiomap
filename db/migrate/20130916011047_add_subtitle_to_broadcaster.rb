class AddSubtitleToBroadcaster < ActiveRecord::Migration
  def change
    add_column :broadcasters, :subtitle, :string
  end
end
