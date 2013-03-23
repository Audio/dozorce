require_relative 'spec_helper'
require_relative '../plugins/youtube'


describe Youtube do
  include SpecHelper

  before(:all) do
    initialize_plugin(Youtube)
  end

  it "should reply to long URLs" do
    should_reply('http://www.youtube.com/watch?v=K-CElVjlY08', 'YouTube: I Will Return - Springwater')
    should_reply('http://www.youtube.com/watch?user=troub&v=K-CElVjlY08&feature=feedf', 'YouTube: I Will Return - Springwater')
  end

  it "should not reply to invalid long URLs" do
    should_not_reply('http://www.youtube.com/watch?user=troub&v=K-CElVjlY08C&feature=feedf')
    should_not_reply('http://www.youtube.com/omgaaaaaaaa&v=')
  end

  it "should reply to short URLs" do
    should_reply('http://youtu.be/K-CElVjlY08', 'YouTube: I Will Return - Springwater')
    should_reply('http://youtu.be/K-CElVjlY08&feature=feedf', 'YouTube: I Will Return - Springwater')
  end

  it "should not reply to invalid short URLs" do
    should_not_reply('http://youtu.be/K-CElVjlY0&feature=feedf')
    should_not_reply('http://youtu.be/K-CEla?jlY08&feature=feedf')
    should_not_reply('http://youtu.be/K-CEEEElVjlY08&feature=feedf')
  end
end
