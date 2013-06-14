require 'cgi'
require_relative '../utils/webpage'


class Track
  include Cinch::Plugin

  set :help, 'track list - prints all tracked users. Plugin prints new ratings automatically in a short interval.'

  match /track list$/

  listen_to :connect, method: :init_ratings
  timer 120, method: :update_ratings

  class << self
    attr_accessor :users

    def configure(&block)
      yield self
    end
  end

  def initialize(*args)
    super
    @users = self.class.users
    @last_titles = {}
    @init_done = false
  end

  def init_ratings(m)
    doc_items = download_parse
    doc_items.each { |user, items| @last_titles[user] = movie_id(items[0])  }
    @init_done = true
  end

  def update_ratings
    return unless @init_done
    doc_items = download_parse
    doc_items.each { |user, items|
      new_items = []
      last_movie_contained = false
      items.each { |item|
        if (movie_id(item) == @last_titles[user])
          last_movie_contained = true
          break
        end
      }
      break unless last_movie_contained

      items.each { |item|
        break if movie_id(item) == @last_titles[user]
        new_items << "Rated #{item[:rating]}* - #{movie_name(item)} (#{movie_link(item)})"
      }
      @last_titles[user] = movie_id(items[0])

      unless new_items.empty?
        message = new_items.reverse.join(' | ')
        message = "#{user.to_s}: #{message}"
        @bot.channels.each { |channel| channel.send message }
      end
    }
  end

  def download_parse
    doc_items = {}
    threads = []
    @users.each { |user, csfd_id|
      threads << Thread.new {
        begin
          doc = WebPage.load_json("http://csfdapi.cz/user/#{csfd_id}")
          doc_items[user] = doc[:ratings]
        rescue Exception => e
          $stderr.puts "Fetching Csfd user `#{user}` failed, error: " + e.message
        end
      }
    }
    threads.each { |thread| thread.join }
    doc_items
  end

  def movie_id(item)
    item[:movie][:id]
  end

  def movie_name(item)
    movie_names = item[:movie][:name]
    movie_names[movie_names.keys.first]
  end

  def movie_link(item)
    item[:movie][:csfd_url]
  end
  def execute(m)
    m.reply "Monitored users: #{@users.keys.join(', ')}"
  end
end
