#json.array!(@broadcasters) do |broadcaster|
#  pry
#  json.extract! broadcaster, :display_name, :callsign, :frequency
#  json.url broadcaster_url(broadcaster, format: :json)
#end

#json.type "FeatureCollection"
#json.features(@broadcasters) do |broadcaster|
#  json.type "Feature"
#  json.geometry broadcaster.contour
#  json.properties do
#    json.extract! broadcaster, :display_name, :callsign, :frequency, :summary
#  end
#end

#json.array!(@broadcasters) do |broadcaster|
#  json.extract! broadcaster, :id#, :display_name, :callsign, :frequency
#  #json.url broadcaster_url(broadcaster, format: :json)
#end

json.broadcaster_ids @broadcasters.map { |b| b.id }
  
