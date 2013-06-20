require 'cgi'
require_relative '../utils/webpage'


class Weather
  include Cinch::Plugin

  set :help, 'jak je v [query] - returns info about current weather in specified location . Example: jak je v Praha'

  match /jak je v (.+)/

  def execute(m, query)
    m.reply( search(query), true)
  end

  def search(location)
    location_url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{CGI.escape(location)}&sensor=false"
    location_result = WebPage.load_json(location_url)
    raise NoLocationFound if location_result[:status] == "ZERO_RESULTS"
    location_coords =  location_result[:results][0][:geometry][:location]

    weather_url = "http://api.met.no/weatherapi/locationforecast/1.8/?lat=#{location_coords[:lat]};lon=#{location_coords[:lng]}"
    weather_result = WebPage.load_xml(weather_url)

    temperature = weather_result.xpath("//weatherdata//product//time//location//temperature").first["value"]
    "#{temperature} Celsius degrees"
  rescue NoLocationFound
    "No such location found"
  rescue
    "No result"
  end
end

class NoLocationFound < StandardError; end
