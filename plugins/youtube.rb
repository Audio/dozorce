require 'nokogiri'
require 'open-uri'


class Youtube
  include Cinch::Plugin

  LONG_URL = /youtube\.com.*v=([^&$]{11})(&|#| |$)/
  SHORT_URL = /youtu\.be\/([^&\?$]{11})(&|#| |$)/

  match LONG_URL, use_prefix: false
  match SHORT_URL, use_prefix: false

  def initialize(*args)
    super
    @cache = {}
  end

  def execute(m, video_id)
    m.reply('YouTube: ' + title(video_id) )
  end

  def title(video_id)
    unless @cache.has_key?(video_id)
      doc = Nokogiri::XML( open('http://gdata.youtube.com/feeds/api/videos/' + video_id) )
      @cache[video_id] = doc.xpath('//media:title').first.content
    end

    @cache[video_id]
  end
end
