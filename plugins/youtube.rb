require 'cinch'
require 'nokogiri'
require 'open-uri'


class Youtube
    include Cinch::Plugin

    @@long_url = /youtube\.com.*v=([^&$]{11})(&|#| |$)/
    @@short_url = /youtu\.be\/([^&\?$]{11})(&|#| |$)/

    match @@long_url, use_prefix: false
    match @@short_url, use_prefix: false

    def execute(m, video_id)
        m.reply( 'YouTube: ' + title(video_id) )
    end

    def title(video_id)
        doc = Nokogiri::XML( open('http://gdata.youtube.com/feeds/api/videos/' + video_id) )
        return doc.xpath('//media:title').first.content
    end

    def long_url_pattern
        @@long_url
    end

    def short_url_pattern
        @@short_url
    end
end
