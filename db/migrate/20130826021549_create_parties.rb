class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :address1
      t.string :address2
      t.string :citizenship
      t.string :city
      t.string :company
      t.string :country
      t.string :email
      t.string :fax
      t.string :legal_name
      t.string :name
      t.string :phone
      t.string :state
      t.string :zip1
      t.string :zip2
      t.datetime :last_change_date
      t.string :crap1
      t.string :crap2
    end
    
    create_table :facilities_parties do |t|
      t.integer :facility_id
      t.integer :party_id
      t.string :party_type
      t.datetime :last_change_date
      t.string :crap1
      t.string :crap2
    end
    
    execute "
      copy parties (id, address1, address2, citizenship, city, company, country, email, fax, legal_name,
        name, phone, state, zip1, zip2, last_change_date, crap1, crap2)
      from '/srv/www/publicradiomap/data/fcc/party.dat' (format csv, delimiter '|', quote '\t');
      
      copy facilities_parties (facility_id, party_id, party_type, last_change_date, crap1, crap2)
      from '/srv/www/publicradiomap/data/fcc/fac_party.dat' (format csv, delimiter '|', quote '\t');
    "
    
  end
end
