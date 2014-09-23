cloudmadeUrl = 'http:#{s}.tile.cloudmade.com/1a1b06b230af4efdbb989ea99e9841af/997/256/{z}/{x}/{y}.png'
cloudmadeAttribution = 'Map data &copy; <a href="http:#openstreetmap.org">OpenStreetMap</a> contributors, Imagery &copy; <a href="http:#cloudmade.com">CloudMade</a>'

contourTilesUrl = '/tile/{z}/{x}/{y}/broadcasters.geojson'
window.contours = contours = {}

$(document).ready ->
  cloudmade = L.tileLayer('http://{s}.tile.cloudmade.com/{key}/22677/256/{z}/{x}/{y}.png',
     attribution: 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade'
     key: '8ee2a50541944fb9bcedded5165f09d9'
  )
  
  contourLayer = new L.TileLayer.Vector.Unclipped \
    contourTilesUrl, unclippedOptions, vectorOptions, options:
      updateWhenIdle: true,
      serverZooms: [6],
      minZoom: 2
      
  progress = new L.TileLayer.Progress(contours)

  url = purl(document.location)
  lat = url.param('lat')
  lon = url.param('lon')
  z = url.param('z')
  
  window.map = map = L.map 'map-canvas',
    center: new L.LatLng(lat or 47.605237, lon or -122.324638)
    zoom: z or 9
    layers: [cloudmade, contourLayer]
  
  if not (lat and lon)
    $.getJSON 'http://freegeoip.net/json/?callback=?', null, (options) ->
      map.setView([options.latitude, options.longitude], 9)
  
  L.tileLayer('http://{s}.tile.cloudmade.com/{key}/22677/256/{z}/{x}/{y}.png',
     attribution: 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade'
     key: '8ee2a50541944fb9bcedded5165f09d9'
  ).addTo(map)
  
  cloudmade.addTo(map)
  contourLayer.addTo(map)
  map.on 'moveend', onMoveEnd
  
  map.on 'zoomend', onZoomEnd
    
  $(document).on 'mouseover', '#key li', onKeyHover
  $(document).on 'mouseout', '#key li', onEndKeyHover

  map.on 'updatepath', showBroadcaster

showBroadcaster = (layer) ->
  properties = layer.feature.properties
  color = properties.color
  name = properties.display_name
  
  color_id = color[1..]
  keyItem = $('#key .broadcaster-'+color_id)
  if not keyItem.length
    $('#key').appendSorted """
      <li class="broadcaster-#{color_id}" data-color-id="#{color_id}">
      <span class="color" style="background-color: #{color}">&nbsp;</span>
      #{name}
      <span class="more_info">#{properties.subtitle || ''}</span>
      </li>"""
  

onEachFeature = (feature, layer) ->
  p = feature.properties
  
  layer.on
    mouseover: onFeatureHover,
    mouseout: onEndFeatureHover
  
  layer.bindPopup p.summary
  
  layer.defaultStyle =
    color: p.color
    weight: 5
    opacity: 0.65
    
  layer.setStyle layer.defaultStyle
  
  layer.bindLabel p.frequency+' '+p.band
  
  color_id = p.color[1..]
  contours[color_id] ||= []
  contours[color_id].push layer
  
onMoveEnd = ->
  $('#key').empty()
  updateLink()

onZoomEnd = ->
  contours = {}

onKeyHover = ->
  contour_list = contours[$(this).data('color-id')]
  highlightFeature(f, false) for f in contour_list if contour_list

onEndKeyHover = ->
  contour_list = contours[$(this).data('color-id')]
  resetHighlight(f) for f in contour_list if contour_list
  
onFeatureHover = (e) ->
  highlightFeature(e.target, true)
  
onEndFeatureHover = (e) ->
  resetHighlight(e.target)

updateLink = ->
  $('a#self-link').attr('href', "?lat=#{map.getCenter().lat}&lon=#{map.getCenter().lng}&z=#{map.getZoom()}")

highlightFeature = (layer, scrollIntoView) ->
  layer.setStyle(highlightStyle)

  color_id = layer.feature.properties.color[1..]
  $(".broadcaster-#{color_id}").css('background-color', '#ccc')
  $(".broadcaster-#{color_id}")[0].scrollIntoView() if scrollIntoView
  
  
  if (!L.Browser.ie && !L.Browser.opera)
    layer.bringToFront()
  
  layer._showLabel
    latlng: map.layerPointToLatLng \
      layer.closestLayerPoint \
        map.latLngToLayerPoint new L.LatLng(0, 0)
        

resetHighlight = (layer) ->
  layer.setStyle layer.defaultStyle

  color_id = layer.feature.properties.color[1..]
  $(".broadcaster-#{color_id}").css('background-color', 'transparent')
  
  if (!L.Browser.ie && !L.Browser.opera)
    layer.bringToBack()
  
  layer._hideLabel()

jQuery.fn.appendSorted = (el) ->
  this.append el
  this.append this.children().detach().sort (a,b) ->
    a.textContent.localeCompare(b.textContent)

style =
  opacity: 0.3,
  fillOpacity: 0.1

highlightStyle =
  weight: 10
  
unclippedOptions =
  unique: (feature) ->
    return feature.id

vectorOptions =
  style: style
  onEachFeature: onEachFeature
