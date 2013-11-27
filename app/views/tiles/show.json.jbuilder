json.type "FeatureCollection"
json.features(@broadcasters) do |broadcaster|
  json.type "Feature"
  json.id broadcaster.id
  json.geometry broadcaster.contour
  json.properties do
    json.extract! broadcaster, :display_name, :callsign, :subtitle, :frequency, :band, :summary, :color
  end
end