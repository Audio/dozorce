require 'cinch'
require 'rspec'
require_relative '../plugins/youtube'


describe Youtube do
  before(:each) do
    @bot = Cinch::Bot.new {
      configure { |c| c.plugins.plugins = [Youtube] }
      loggers.level = :error
    }
    @plugin = Youtube.new(@bot)
  end

  def message(text)
    double('Cinch::Message', :message => text)
  end

  def should_respond(matcher, plain_messages)
    plain_messages.each { |plain|
      m = message(plain)
      matchdata = matcher[:pattern].match(m.message)
      matchdata.nil?.should be false
      m.should_receive(:reply)
      @plugin.send(matcher[:method], m, matchdata[1])
    }
  end

  def should_not_respond(matcher, plain_messages)
    plain_messages.each { |plain|
      m = message(plain)
      matcher[:pattern].match(m.message).nil?.should be true
    }
  end

  it "should respond to long and short URLs" do
    @plugin.class.matchers.size.should be 2
  end

  it "should be influenced by prefixes" do
    @plugin.class.matchers.each { |matcher| matcher[:use_prefix].should be false }
  end

  it "should respond to long URLs" do
    should_respond(
      @plugin.class.matchers.first,
      %w(http://www.youtube.com/watch?v=8WVTOUh53QY
         http://www.youtube.com/watch?user=troub&v=8WVTOUh53QY&feature=feedf)
    )
  end

  it "should not respond to invalid long URLs" do
    should_not_respond(
      @plugin.class.matchers.first,
      %w(http://www.youtube.com/watch?user=troub&v=8WVTOUh53QAY&feature=feedf
         http://www.youtube.com/omgaaaaaaaa&v=)
    )
  end

  it "should respond to short URLs" do
    should_respond(
      @plugin.class.matchers.last,
      %w(http://youtu.be/8WVTOUh53QY
         http://youtu.be/8WVTOUh53QY&feature=feedf)
    )
  end

  it "should not respond to invalid short URLs" do
    should_not_respond(
      @plugin.class.matchers.first,
      %w(http://youtu.be/8WVTOUh53Q&feature=feedf
         http://youtu.be/8WVTa?Uh53Q&feature=feedf
         http://youtu.be/8WVTaJJJJJUh53Q&feature=feedf)
    )
  end
end
