class AddWikipediaPageToBroadcaster < ActiveRecord::Migration
  def change
    add_column :broadcasters, :wikipedia, :text
  end
end
