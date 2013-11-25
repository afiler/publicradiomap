#json.extract! @broadcaster, :display_name, :callsign, :frequency, :contour
json.type "FeatureCollection"
json.features([@broadcaster]) do |broadcaster|
  json.type "Feature"
  json.geometry broadcaster.contour
  json.properties do
    json.extract! broadcaster, :display_name, :callsign, :subtitle, :frequency, :band, :summary, :color
  end
end