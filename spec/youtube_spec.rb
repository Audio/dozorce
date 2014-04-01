
require 'cinch'
require_relative '../utils/webpage'
require_relative '../plugins/youtube/routes'
require_relative '../plugins/youtube/service'


describe YoutubeRoutes do
  it 'should match long URLs' do
    'http://www.youtube.com/watch?v=K-CElVjlY08'.should match(YoutubeRoutes::LONG_URL)
    'http://www.youtube.com/watch?user=troub&v=K-CElVjlY08&feature=feedf'.should match(YoutubeRoutes::LONG_URL)
  end

  it 'should not match invalid long URLs' do
    'http://www.youtube.com/watch?user=troub&v=K-CElVjlY08C&feature=feedf'.should_not match(YoutubeRoutes::LONG_URL)
    'http://www.youtube.com/omgaaaaaaaa&v='.should_not match(YoutubeRoutes::LONG_URL)
  end

  it 'should match short URLs' do
    'http://youtu.be/K-CElVjlY08'.should match(YoutubeRoutes::SHORT_URL)
    'http://youtu.be/K-CElVjlY08&feature=feedf'.should match(YoutubeRoutes::SHORT_URL)
  end

  it 'should not match invalid short URLs' do
    'http://youtu.be/K-CElVjlY0&feature=feedf'.should_not match(YoutubeRoutes::SHORT_URL)
    'http://youtu.be/K-CEla?jlY08&feature=feedf'.should_not match(YoutubeRoutes::SHORT_URL)
    'http://youtu.be/K-CEEEElVjlY08&feature=feedf'.should_not match(YoutubeRoutes::SHORT_URL)
  end
end


describe YoutubeService do
  before(:all) do
    @instance = YoutubeService.new(WebPage)
  end

  it 'should return video title' do
    title = @instance.fetch_title 'dBGtZ-HMJmI'
    expect(title).to eq('Springwater -  I will return')
  end

  it 'should return error message for invalid video id' do
    title = @instance.fetch_title 'idunno'
    expect(title).to eq('Unavailable video (server returned 400 Bad Request)')
  end

  it 'should return error message for unknown video' do
    title = @instance.fetch_title 'AAABBBCCCDD'
    expect(title).to eq('Unavailable video (server returned 404 Not Found)')
  end
end
