require 'cgi'
require 'nokogiri'
require_relative '../utils/webpage'


class Csfd
  include Cinch::Plugin

  set :help, 'csfd [query] - returns info about queried movie. Example: csfd star wars xxx a porn parody'

  match /csfd (.+)/

  def execute(m, query)
    m.reply( search(query), true)
  end

  def search(query)
    search_url = "http://csfdapi.cz/movie?search=#{CGI.escape(query)}"
    search_result = WebPage.load_json(search_url)
    raise NoMovieFoundError if search_result.length == 0
    movie_id =  search_result[0][:id]

    movie_url = "http://csfdapi.cz/movie/#{movie_id}"
    movie_result = WebPage.load_json(movie_url)

    movie_title = Nokogiri::HTML(movie_result[:names][movie_result[:names].keys.first]).content
    movie_country = movie_result[:countries].join(' / ')
    movie_year = movie_result[:year]
    movie_length = movie_result[:runtime]
    movie_rating = movie_result[:rating]
    movie_link = movie_result[:csfd_url]

    result = "#{movie_title} (#{movie_year}), #{movie_country}, #{movie_length}"
    unless movie_rating.nil?
      result += ", #{movie_rating}%"
    end
    result += " - #{movie_link}"
    result
  rescue
    "No result"
  end
end

class NoMovieFoundError < StandardError; end
