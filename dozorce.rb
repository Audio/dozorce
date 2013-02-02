require 'cinch'
Dir["./plugins/*.rb"].each { |file| require_relative file }


bot = Cinch::Bot.new do
  configure do |c|
    c.nick = 'Sadomaso'
    c.user = 'dozorce'
    c.server = "irc.rizon.net"
    c.channels = ['#abraka']
    c.encoding = 'UTF-8'
    c.plugins.plugins = [
        Bash,
        Calculator,
        Csfd,
        Eval,
        Google,
        Help,
        Title,
        Translator,
        Twitter,
        Wiki,
        Youtube]
    c.plugins.prefix = ''
  end
end

bot.loggers.level = :warn
bot.start
