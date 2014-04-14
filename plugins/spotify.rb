require 'nokogiri'

class Spotify
  include Cinch::Plugin

  Links = {
    :uri_matcher => /spotify\:([a-z]+)\:([a-zA-Z0-9]+)/,
    :http_matcher => /open\.spotify\.com\/([a-z]+)\/([a-zA-Z0-9]+)/
  }

  match Links[:uri_matcher], use_prefix: false, method: :get_http
  match Links[:http_matcher], use_prefix: false, method: :get_uri
  match /track (\w+)/, method: :search_track
  match /album (\w+)/, method: :search_album
  match /artist (\w+)/, method: :search_artist

  def initialize(*args)
    super
    @cache = {}
  end

  def get_http(m, type, id)
    m.reply( get_data(type, id, :http) )
  end

  def get_uri(m, type, id)
    m.reply( get_data(type, id, :uri) )
  end

  def search_track(m, query)
    m.reply( search(:track, query) )
  end

  def search_album(m, query)
    m.reply( search(:album, query) )
  end

  def search_artist(m, query)
    m.reply( search(:artist, query) )
  end

  def get_data(type, id, matcher)
    key = "#{type}:#{id}"
    unless @cache.has_key?(key)
      doc = WebPage.load_json( "http://ws.spotify.com/lookup/1/.json?uri=spotify:#{type}:#{id}" )
      data = doc[type.to_sym]
      res = "#{type.capitalize}: "
      case type.to_sym
        when :track
          res += "#{data[:name]} - #{data[:artists][0][:name]} (#{data[:album][:name]} - #{data[:album][:released]})"
        when :album
          res += "#{data[:artist]} - #{data[:name]} (#{data[:released]})"
        when :artist
          res += "#{data[:name]}"
        else
          "No result"
      end

      if matcher == :uri
        res += " - http://open.spotify.com/#{type}/#{id}"
      end

      @cache[key] = res
    end

    @cache[key]
  end

  def search(type, query)
    key = "search:#{type}:#{query}"
    unless @cache.has_key?(key)
      doc = WebPage.load_json( "https://ws.spotify.com/search/1/#{type}.json?q=#{CGI.escape(query)}" )
      data = doc[(type.to_s + "s").to_sym][0]
      res = "#{type.capitalize}: "
      link = nil
      case type.to_sym
        when :track
          res += "#{data[:name]} - #{data[:artists][0][:name]} (#{data[:album][:name]} - #{data[:album][:released]})"
          link = data[:href]
        when :album
          res += "#{data[:artists][0][:name]} - #{data[:name]}"
          link = data[:href]
        when :artist
          res += "#{data[:name]}"
          link = data[:href]
        else
          "No result"
      end

      matcher = link.match(Links[:uri_matcher])
      res += " - http://open.spotify.com/#{matcher[1].to_s}/#{matcher[2].to_s}"

      @cache[key] = res
    end

    @cache[key]
  end
end