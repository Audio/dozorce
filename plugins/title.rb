require 'cinch'
require 'webpage'


class Title
    include Cinch::Plugin

    match /^t +(http.+)/, use_prefix: false

    def execute(m, url)
        m.reply( WebPage.new(url).title )
    end
end
