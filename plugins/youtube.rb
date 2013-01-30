require_relative '../utils/webpage'


class Youtube
  include Cinch::Plugin

  set :help, 'YouTube plugin automatically prints video titles from detected URLs.'

  match /youtube\.com.*v=([^&$]{11})(&|#| |$)/, use_prefix: false
  match /youtu\.be\/([^&\?$]{11})(&|#| |$)/, use_prefix: false

  def initialize(*args)
    super
    @cache = {}
  end

  def execute(m, video_id)
    m.reply("YouTube: #{title(video_id)}")
  end

  private
  def title(video_id)
    unless @cache.has_key?(video_id)
      doc = WebPage.load_xml("http://gdata.youtube.com/feeds/api/videos/#{video_id}")
      @cache[video_id] = doc.xpath('//media:title').first.content
    end

    @cache[video_id]
  end
end
