class CaFacility < ActiveRecord::Base
  def community
    city.strip
  end
  
  def callsign
    read_attribute(:callsign).strip
  end
  
  def frequency
    if band == 'FM'
      "%2.1f" % read_attribute(:frequency)
    else
      "%3d" % read_attribute(:frequency)
    end
  end
  
end
