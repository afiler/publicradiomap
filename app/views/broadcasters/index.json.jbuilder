json.array!(@broadcasters) do |broadcaster|
  json.extract! broadcaster, 
  json.url broadcaster_url(broadcaster, format: :json)
end
