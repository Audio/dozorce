
require_relative '../../utils/webpage'
require_relative './services/youtube'
require_relative './config'


module Youtube

  class Plugin
    include Cinch::Plugin

    set :help, 'YouTube plugin automatically prints video titles from detected URLs.'

    match Config[:routes][:long_url], use_prefix: false
    match Config[:routes][:short_url], use_prefix: false

    def initialize(*args)
      super
      @youtube = Services::Youtube.new(WebPage)
    end

    def execute(m, video_id)
      m.reply("YouTube: #{@youtube.fetch_title(video_id)}")
    end
  end

end
