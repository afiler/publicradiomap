class CaFacility < ActiveRecord::Base
  def community
    city.strip
  end
  
  def frequency
    read_attribute(:frequency).to_f.to_s
  end
  
end
