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
    double = double('Cinch::Message', :message => text)
    double.should_receive(:match).any_number_of_times do |regex, type| text.match(regex) end
    double
  end

  def should_reply(plain_messages)
    test_replies(:once, plain_messages)
  end

  def should_not_reply(plain_messages)
    test_replies(0, plain_messages)
  end

  private
  def test_replies(count, plain_messages)
    event = :message
    plain_messages.each { |message|
      msg = message(message)
      msg.should_receive(:reply).exactly(count).times
      handlers = @bot.handlers.find(event, msg)
      handlers.each do |handler|
        captures = msg.match(handler.pattern.to_r(msg), event).captures
        handler.block.call(msg, *handler.args, *captures)
      end
    }
  end
end
