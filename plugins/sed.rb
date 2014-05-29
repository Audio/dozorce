
class Sed
  include Cinch::Plugin

  set :help, 's/*old*/*new*/ - replaces *old* part of your last message with *new*'

  listen_to :channel

  def initialize(*args)
    super
    @messages = { }
  end

  def listen(m)
    # We can't use execute and match, because listen rewrites the last message
    # with s/X/Y/ before execute is called.
    match = /^s\/([^\/]*)\/([^\/]*)\/?g?$/.match(m.message)
    if match && match.length >= 3 then
      replace(m, match[1], match[2])
    else
      @messages[m.channel] = { } unless @messages.include?(m.channel)
      @messages[m.channel][m.user.nick] = m.message
    end
  end

  def replace(m, pOld, pNew)
    return unless @messages.include?(m.channel) && @messages[m.channel].include?(m.user.nick)
    msg = @messages[m.channel][m.user.nick].clone
    msg.gsub! pOld, pNew
    m.reply(msg) unless not msg
  end
end
