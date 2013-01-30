require 'cinch'
Dir["./plugins/*.rb"].each { |file| require_relative file }


bot = Cinch::Bot.new do
  configure do |c|
    c.nick = 'Kapustnak'
    c.user = 'dozorce'
    c.server = "irc.rizon.net"
    c.channels = ["#abraka"]
    c.plugins.plugins = [Bash, Calculator, Die, Eval, Google, Help, Title, Translator, Youtube]
    c.plugins.prefix = '.'
  end
end

bot.loggers.level = :warn
bot.start
