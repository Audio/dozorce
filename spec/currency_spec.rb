require 'cinch'
require 'rspec'
require_relative '../plugins/currency'


describe Currency do
  before(:each) do
    @bot = Cinch::Bot.new {
      configure { |c| c.plugins.plugins = [Currency] }
      loggers.level = :error
    }
    @plugin = Currency.new(@bot)
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
      matcher[:pattern].match(m.message).nil?.should be false
      m.should_receive(:reply)
      @plugin.send(matcher[:method], m)
    }
  end

  def should_not_respond(matcher, plain_messages)
    plain_messages.each { |plain|
      m = message(plain)
      m = check_and_remove_prefix(matcher, m)
      matcher[:pattern].match(m.message).nil?.should be true
    }
  end

  it "should respond to prefixed and unprefixed messages" do
    @plugin.class.matchers.size.should be 2
  end

  it "should respond to prefixed messages" do
    should_respond(
      @plugin.class.matchers.first,
      [ '.c 15 usd to czk',
        '.c 17.2 usd to czk',
        '.c 17,2 usd to czk']
    )
  end

  it "should not respond to invalid prefixed messages" do
    should_not_respond(
      @plugin.class.matchers.first,
      [ '.c ahoj :))',
        '.c 17.a usd to czk' ]
    )
  end

  it "should respond to unprefixed messages" do
    should_respond(
      @plugin.class.matchers.last,
      [ '192 pounds to kg',
        '18 stones to grams' ]
    )
  end

  it "should not respond to unprefixed messages" do
    should_not_respond(
      @plugin.class.matchers.last,
      [ 'zdarec!',
        '17.a usd to czk' ]
    )
  end
end
