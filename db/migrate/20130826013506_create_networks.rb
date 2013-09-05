class CreateNetworks < ActiveRecord::Migration
  def foo
    create_table :networks do |t|
      t.string :fac_address1
      t.string :fac_zip1
      t.boolean :has_broadcaster
    end
    
    add_index :networks, :fac_address1
    add_index :networks, :fac_zip1

    add_column :facilities, :network_id, :integer
    add_index :facilities, :fac_callsign
    add_index :facilities, :fac_address1
    add_index :facilities, :fac_zip1
    
    q = %Q{
      insert into networks (fac_address1, fac_zip1)
        select distinct fac_address1, fac_zip1 from facilities;
      
      update facilities set network_id = networks.id from networks
      where facilities.fac_address1 = networks.fac_address1 and facilities.fac_zip1 = networks.fac_zip1;
      
      update networks set has_broadcaster=true where id in (
         select n.id from networks n
         join facilities f on f.network_id = n.id
         join broadcasters b on b.facility_id = f.id
         group by n.id
         having count(n.id) > 1
      );
    }
    #execute q
    
  end
end
