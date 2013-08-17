class AddMoreCrapToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :crap3, :string
  end
end
