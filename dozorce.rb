
require 'cinch'
Dir["./plugins/*.rb"].each { |file| require_relative file }
Dir["./plugins/*/plugin.rb"].each { |file| require_relative file }


bot = Cinch::Bot.new do
  configure do |c|
    c.nick = 'DoziARM'
    c.user = 'dozorce'
    c.server = "irc.rizon.net"
    c.channels = ['#soulwell']
    c.encoding = 'UTF-8'
    c.plugins.plugins = [
        Bash,
        Calculator::Plugin,
        Catcore::Plugin,
        Csfd,
        Google,
        Help,
        Rejoin,
        Rss,
        Sed,
        Spotify,
        Title,
        Track,
        Translator,
        Twitter,
        Weather,
        Wiki,
        Youtube::Plugin]
    c.plugins.prefix = ''
  end
end

Track.configure do |c|
  c.users = {
      :Audio    => 119558,
      :Frca     => 65159,
      :Hate     => 256535,
      :Chaythere=> 122253,
      :reeshack => 95093,
      :Tassoid  => 365840,
  }
  c.api_url = 'http://csfdapi.cz/'
end

Csfd.configure do |c|
  c.api_url = 'http://csfdapi.cz/'
end

Rss.configure do |c|
  c.feeds = {
      :adt             => 'https://sites.google.com/a/android.com/tools/recent/posts.xml',
      :AndroidDeals    => 'http://www.androidpolice.com/topics/deals-2/feed/',
      :dozorce         => 'https://github.com/Audio/dozorce/commits/master.atom',
      :Lorris          => 'https://github.com/Tasssadar/Lorris/commits/master.atom',
      :LorrisMobile    => 'https://github.com/Tasssadar/lorris_mobile/commits/master.atom',
      :Steam           => 'http://www.rssitfor.me/getrss?name=steam_games',
      :Wine            => 'https://www.winehq.org/news/rss/'
  }
end

bot.loggers.level = :warn
bot.start
