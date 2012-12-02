require_relative 'spec_helper'
require_relative '../plugins/youtube'


describe Youtube do
  include SpecHelper

  before(:all) do
    initialize_plugin(Youtube)
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
