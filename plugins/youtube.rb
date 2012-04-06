require 'cinch'
require 'nokogiri'
require 'open-uri'


class Youtube
    include Cinch::Plugin

    attr_reader :reg_long, :reg_short

    def initialize(bot)
        super(bot)
        @reg_long = /youtube\.com.*v=([^&$]{11})(&| |$)/
        @reg_short = /youtu\.be\/([^&\?$]{11})(&| |$)/
    end

    match @reg_long, use_prefix: false
    match @reg_short, use_prefix: false

    def execute(m, video_id)
        m.reply( 'YouTube: ' + title(video_id) )
    end

    def title(video_id)
        doc = Nokogiri::XML( open('http://gdata.youtube.com/feeds/api/videos/' + video_id) )
        return doc.xpath('//media:title').first.content
    end
end
