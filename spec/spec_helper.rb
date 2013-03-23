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

  def should_reply(text, reply)
    event = :message
    message = message(text)
    message.should_receive(:reply).with(reply)
    handlers = @bot.handlers.find(event, message)
    handlers.each do |handler|
      captures = message.match(handler.pattern.to_r(message), event).captures
      handler.block.call(message, *handler.args, *captures)
    end
  end

  def should_not_reply(text)
    @bot.handlers.find(:message, message(text)).size.should be 0
  end
end
