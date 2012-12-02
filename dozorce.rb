require 'cinch'
Dir["./plugins/*.rb"].each { |file| require_relative file }


bot = Cinch::Bot.new do
  configure do |c|
    c.nick = 'Kapustnak'
    c.user = 'dozorce'
    c.server = "irc.rizon.net"
    c.channels = ["#abraka"]
    c.plugins.plugins = [Currency, Die, Eval, Title, Youtube]
  end
end

bot.loggers.level = :warn
bot.start
