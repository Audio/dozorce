require 'cinch'
require 'nokogiri'
require 'open-uri'


class Youtube
    include Cinch::Plugin

    @reg_long = /youtube\.com.*v=([^&$]{11})(&| |$)/
    @reg_short = /youtu\.be\/([^&\?$]{11})(&| |$)/

    match @reg_long, use_prefix: false
    match @reg_short, use_prefix: false

    def execute(m, video_id)
        m.reply( title(video_id) )
    end

    def title(video_id)
        doc = Nokogiri::XML( open('http://gdata.youtube.com/feeds/api/videos/' + video_id) )
        return doc.xpath('//media:title').first.content
    end
end
