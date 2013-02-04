require 'cgi'
require_relative '../utils/simple-rss'
require_relative '../utils/webpage'


class Rss
  include Cinch::Plugin

  set :help, 'rss list - prints the list of feeds. Plugin prints new messages automatically in a short interval.'

  match /rss list$/

  listen_to :connect, method: :init_feeds
  timer 60, method: :update_feeds

  class << self
    attr_accessor :feeds

    def configure(&block)
      yield self
    end
  end

  def initialize(*args)
    super
    @feeds = self.class.feeds
    @last_titles = {}
    @init_done = false
  end

  def init_feeds(m)
    @feeds.each { |feed, url|
      rss = SimpleRSS.parse WebPage.load(url)
      @last_titles[feed] = rss.items.first.title
    }
    @init_done = true
  end

  def update_feeds
    return unless @init_done
    @feeds.each { |feed, url|
      new_items = []
      rss = SimpleRSS.parse WebPage.load(url)
      rss.items.each { |item|
        break if item.title == @last_titles[feed]
        new_items << CGI.unescapeHTML(item.title)
      }
      @last_titles[feed] = rss.items.first.title

      unless new_items.empty?
        message = new_items.reverse.join(' | ')
        message = "#{feed.to_s}: #{message}"
        @bot.channels.each { |channel| channel.send message }
      end
    }
  end

  def execute(m)
    m.reply "Monitored feeds: #{@feeds.keys.join(', ')}"
  end
end
