require_relative 'spec_helper'
require_relative '../plugins/calculator'


describe Calculator do
  include SpecHelper

  before(:all) do
    initialize_plugin(Calculator)
  end

  it "should reply to prefixed messages" do
    should_reply(
      [ '!c 15 usd to czk',
        '!c 17.2 usd to czk',
        '!c 9 + 9']
    )
  end

  it "should reply to possibly invalid prefixed messages" do
    should_reply(
      [ '!c 17.a usd to czk' ]
    )
  end

  it "should reply to unprefixed messages" do
    should_reply(
      [ '192 pounds to kg',
        '18 stones to grams' ]
    )
  end

  it "should not reply to unprefixed messages" do
    should_not_reply(
      [ 'zdarec!',
        '17.a usd to czk' ]
    )
  end
end
