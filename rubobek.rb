$LOAD_PATH << 'lib' << 'plugins'

require 'cinch'
require 'die'
require 'youtube'


bot = Cinch::Bot.new do
    configure do |c|
        c.nick = 'Zuckerberg'
        c.user = 'rubobek'
        c.server = "irc.rizon.net"
        c.channels = ["#soulwell"]
        c.plugins.plugins = [Die, Youtube]
    end
end

bot.start
