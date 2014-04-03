#encoding: utf-8
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
        Calculator,
        Csfd,
        Google,
        Help,
        Rejoin,
        Rss,
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

Calculator.configure do |c|
  c.currency_shortcut = {
      :to   => 'czk',
      :from => %w(usd eur euro euros),
      :symbols => {
          :usd   => '$',
          :eur   => '€',
          :pound => '£'
      }
  }
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
      :bashoid         => 'https://github.com/Audio/bashoid/commits/master.atom',
      :dozorce         => 'https://github.com/Audio/dozorce/commits/master.atom',
      :fIRC            => 'https://github.com/Frca/fIRC/commits/master.atom',
      :GamingScheduler => 'https://github.com/Frca/GamingScheduler/commits/master.atom',
      :Lorris          => 'https://github.com/Tasssadar/Lorris/commits/master.atom',
      :LorrisMobile    => 'https://github.com/Tasssadar/lorris_mobile/commits/master.atom',
      :Steam           => 'http://www.rssitfor.me/getrss?name=steam_games',
      :TrinityCore     => 'https://github.com/TrinityCore/TrinityCore/commits/master.atom',
      :Wine            => 'http://www.winehq.org/news/rss/'
  }
end

bot.loggers.level = :warn
bot.start
