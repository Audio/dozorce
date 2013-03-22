require_relative 'spec_helper'
require_relative '../plugins/youtube'


describe Youtube do
  include SpecHelper

  before(:all) do
    initialize_plugin(Youtube)
  end

  it "should not be used with prefixes" do
    @plugin.class.matchers.each { |matcher| matcher[:use_prefix].should be false }
  end

  it "should reply to long URLs" do
    should_reply(
      %w(http://www.youtube.com/watch?v=8WVTOUh53QY
         http://www.youtube.com/watch?user=troub&v=8WVTOUh53QY&feature=feedf)
    )
  end

  it "should not reply to invalid long URLs" do
    should_not_reply(
      %w(http://www.youtube.com/watch?user=troub&v=8WVTOUh53QAY&feature=feedf
         http://www.youtube.com/omgaaaaaaaa&v=)
    )
  end

  it "should reply to short URLs" do
    should_reply(
      %w(http://youtu.be/8WVTOUh53QY
         http://youtu.be/8WVTOUh53QY&feature=feedf)
    )
  end

  it "should not reply to invalid short URLs" do
    should_not_reply(
      %w(http://youtu.be/8WVTOUh53Q&feature=feedf
         http://youtu.be/8WVTa?Uh53Q&feature=feedf
         http://youtu.be/8WVTaJJJJJUh53Q&feature=feedf)
    )
  end
end
