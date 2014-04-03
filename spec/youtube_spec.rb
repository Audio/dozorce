
require 'cinch'
require_relative '../utils/webpage'
require_relative '../plugins/youtube/services/youtube'
require_relative '../plugins/youtube/config'


describe Youtube::Config do
  before :all do
    @LONG_URL = Youtube::Config[:routes][:long_url]
    @SHORT_URL = Youtube::Config[:routes][:short_url]
  end

  it 'should match long URLs' do
    'http://www.youtube.com/watch?v=K-CElVjlY08'.should match @LONG_URL
    'http://www.youtube.com/watch?user=troub&v=K-CElVjlY08&feature=feedf'.should match @LONG_URL
  end

  it 'should not match invalid long URLs' do
    'http://www.youtube.com/watch?user=troub&v=K-CElVjlY08C&feature=feedf'.should_not match @LONG_URL
    'http://www.youtube.com/omgaaaaaaaa&v='.should_not match @LONG_URL
  end

  it 'should match short URLs' do
    'http://youtu.be/K-CElVjlY08'.should match @SHORT_URL
    'http://youtu.be/K-CElVjlY08&feature=feedf'.should match @SHORT_URL
  end

  it 'should not match invalid short URLs' do
    'http://youtu.be/K-CElVjlY0&feature=feedf'.should_not match @SHORT_URL
    'http://youtu.be/K-CEla?jlY08&feature=feedf'.should_not match @SHORT_URL
    'http://youtu.be/K-CEEEElVjlY08&feature=feedf'.should_not match @SHORT_URL
  end
end


describe Youtube::Services::Youtube do
  before :all do
    @instance = Youtube::Services::Youtube.new(WebPage)
  end

  it 'should return video title' do
    title = @instance.fetch_title 'dBGtZ-HMJmI'
    expect(title).to eq 'Springwater -  I will return'
  end

  it 'should return error message for invalid video id' do
    title = @instance.fetch_title 'idunno'
    expect(title).to eq 'Unavailable video (server returned 400 Bad Request)'
  end

  it 'should return error message for unknown video' do
    title = @instance.fetch_title 'AAABBBCCCDD'
    expect(title).to eq 'Unavailable video (server returned 404 Not Found)'
  end
end
