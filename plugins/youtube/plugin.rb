
require_relative '../../utils/webpage'
require_relative './routes'
require_relative './service'


class YoutubePlugin
  include Cinch::Plugin

  set :help, 'YouTube plugin automatically prints video titles from detected URLs.'

  match YoutubeRoutes::LONG_URL, use_prefix: false
  match YoutubeRoutes::SHORT_URL, use_prefix: false

  def initialize(*args)
    super
    @youtube = YoutubeService.new(WebPage)
  end

  def execute(m, video_id)
    m.reply("YouTube: #{@youtube.fetch_title(video_id)}")
  end
end
