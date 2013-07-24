require 'cgi'
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
    doc_items = download_parse
    doc_items.each { |feed, items| @last_titles[feed] = title(items)  }
    @init_done = true
  end

  def update_feeds
    return unless @init_done
    doc_items = download_parse
    doc_items.each { |feed, items|
      new_items = []
      unless @last_titles[feed].empty?
        items.each { |item|
          break if title(item) == @last_titles[feed]
          new_items << CGI.unescapeHTML( title(item) )
        }
      end

      @last_titles[feed] = title(items)

      unless new_items.empty?
        message = new_items.reverse.join(' | ')
        message = "#{feed.to_s}: #{message}"
        @bot.channels.each { |channel| channel.send message }
      end
    }
  end

  def download_parse
    doc_items = {}
    threads = []
    @feeds.each { |feed, url|
      threads << Thread.new {
        begin
          doc = WebPage.load_xml(url)
          is_rss = doc.xpath('/rss').size > 0
          doc.remove_namespaces! unless is_rss

          items_path = is_rss ? '/rss/channel/item' : '/feed/entry'
          items = doc.xpath(items_path)

          doc_items[feed] = items
        rescue Exception => e
          $stderr.puts "Fetching RSS " + url + " failed, error: " + e.message
        end
      }
    }
    threads.each { |thread| thread.join }
    doc_items
  end

  def title(item)
    item.at('title').text.strip
  end

  def execute(m)
    m.reply "Monitored feeds: #{@feeds.keys.join(', ')}"
  end
end
