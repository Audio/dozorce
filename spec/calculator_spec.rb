require_relative 'spec_helper'
require_relative '../plugins/calculator'


describe Calculator do
  include SpecHelper

  before(:all) do
    initialize_plugin(Calculator)
  end

  it "should reply to prefixed messages" do
    should_reply('!c 0.00000001 au to km', '1.49597871 kilometers')
    should_reply('!c 33.8 f to c', '1 degree Celsius')
    should_reply('!c 9 + 9', '18')
  end

  it "should reply to possibly invalid prefixed messages" do
    should_reply('!c 17.a usd to czk', 'No result')
  end

  it "should reply to unprefixed messages" do
    should_reply('33.8 f to c', '1 degree Celsius')
    should_reply('18 stones to kilograms', '114.305277 kilograms')
  end

  it "should not reply to invalid unprefixed messages" do
    should_not_reply('zdarec!')
    should_not_reply('17.a usd to czk')
  end
end
