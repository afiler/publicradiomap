class AddCrapToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :crap1, :string
    add_column :facilities, :crap2, :string
  end
end
