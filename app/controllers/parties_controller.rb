class PartiesController < ApplicationController
  def index
    @parties = Party.find_by_sql "
      select array_agg(p.id) as ids, p.name, count(p.name) as c, array_agg(f.fac_callsign) as callsigns
      from parties p
      join facilities_parties fp on fp.party_id=p.id
      join facilities f on fp.facility_id=f.id
      join broadcasters b on b.facility_id = f.id
      group by p.name
      having count(p.name) > 1
      order by c desc;"
  end
end