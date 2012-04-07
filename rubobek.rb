$LOAD_PATH << 'lib' << 'utils' << 'plugins'

require 'cinch'
require 'die'
require 'title'
require 'youtube'


bot = Cinch::Bot.new do
    configure do |c|
        c.nick = 'TomHanks'
        c.user = 'halyvud'
        c.server = "irc.rizon.net"
        c.channels = ["#abraka"]
        c.plugins.plugins = [Die, Youtube, Title]
    end
end

bot.loggers.level = :warn
bot.start
