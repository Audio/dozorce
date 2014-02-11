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
    @@api_accessable = true
  end

  def init_ratings(m)
    doc_items = download_parse
    if @@api_accessable
      doc_items.each { |user, items| @last_titles[user] = movie_id(items[0])  }
    end
    @init_done = true
  end

  def update_ratings
    return unless @init_done
    return init_ratings(nil) if @last_titles.empty?

    doc_items = download_parse
    return unless @@api_accessable

    doc_items.each { |user, items|
      handle_feed(user,items)
      @last_titles[user] = movie_id(items[0])
    }
  end

  def handle_feed(user, items)
    return if @last_titles[user].nil?

    new_items = []
    last_movie_contained = false
    items.each { |item|
      if (movie_id(item) == @last_titles[user])
        last_movie_contained = true
        break
      end
    }
    return unless last_movie_contained

    items.each { |item|
      break if movie_id(item) == @last_titles[user]
      new_items << "Rated #{item[:rating]}* - #{movie_name(item)} (#{movie_link(item)})"
    }

    unless new_items.empty?
      message = new_items.reverse.join(' | ')
      message = "#{user.to_s}: #{message}"
      @bot.channels.each { |channel| channel.send message }
    end
  end

  def download_parse
    doc_items = {}
    threads = []
    is_api_running = true
    @users.each { |user, csfd_id|
      threads << Thread.new {
        begin
          doc = WebPage.load_json("http://csfdapi.cz/user/#{csfd_id}")
          doc_items[user] = doc[:ratings]
        rescue OpenURI::HTTPError => e
          if e.message.strip.eql? "500"
            is_api_running = false
            threads.each { |thread| thread.exit }
          else
            $stderr.puts "Fetching Csfd user `#{user}` failed, error: " + e.message
          end
        end
      }
    }
    threads.each { |thread| thread.join }
    if @@api_accessable != is_api_running
      $stderr.puts is_api_running ? "Csfd api is accessible again" : "Csfd api is not currently accessible"
      @@api_accessable = is_api_running
    end

    doc_items
  end

  def movie_id(item)
    item[:movie][:id]
  end

  def movie_name(item)
    movie_names = item[:movie][:names]
    movie_names[movie_names.keys.first]
  end

  def movie_link(item)
    item[:movie][:csfd_url]
  end
  def execute(m)
    m.reply "Monitored users: #{@users.keys.join(', ')}"
  end

  def self.is_api_accessible?
    @@api_accessable
  end
end
