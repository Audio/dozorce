require 'cinch'
require 'rspec'


module SpecHelper
  def initialize_plugin(plugin_class)
    @bot = Cinch::Bot.new {
      configure { |c| c.plugins.plugins = [plugin_class] }
      loggers.level = :error
    }
    @plugin = plugin_class.new(@bot)
  end

  def message(text)
    double('Cinch::Message', :message => text)
  end

  def check_and_remove_prefix(matcher, m)
    if matcher[:use_prefix]
      m.message.match(/^#{matcher[:prefix]}/).nil?.should be false
      m.message.sub!(/^#{matcher[:prefix]}/, '').strip!
    end
    m
  end

  def should_respond(matcher, plain_messages)
    plain_messages.each { |plain|
      m = message(plain)
      m = check_and_remove_prefix(matcher, m)
      matchdata = matcher[:pattern].match(m.message)
      matchdata.nil?.should be false

      m.should_receive(:reply)
      callback = @plugin.method(matcher[:method])
      if callback.arity == 1
        callback.call(m)
      else
        callback.call(m, matchdata[1])
      end
    }
  end

  def should_not_respond(matcher, plain_messages)
    plain_messages.each { |plain|
      m = message(plain)
      m = check_and_remove_prefix(matcher, m)
      matcher[:pattern].match(m.message).nil?.should be true
    }
  end
end
