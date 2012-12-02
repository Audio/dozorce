require_relative 'spec_helper'
require_relative '../plugins/currency'


describe Currency do
  include SpecHelper

  before(:all) do
    initialize_plugin(Currency)
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
