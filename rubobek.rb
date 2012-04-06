$LOAD_PATH << 'lib' << 'plugins'

require 'cinch'
require 'die'
require 'youtube'


bot = Cinch::Bot.new do
    configure do |c|
        c.nick = 'TomHanks'
        c.user = 'halyvud'
        c.server = "irc.rizon.net"
        c.channels = ["#abraka"]
        c.plugins.plugins = [Die, Youtube]
    end
end

bot.loggers.level = :warn
bot.start
