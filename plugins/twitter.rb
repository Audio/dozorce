require_relative '../utils/webpage'


class Twitter
  include Cinch::Plugin

  set :help, 'Twitter plugin automatically prints tweets from detected URLs.'

  match /twitter.com\/(\w*\/status\/\d+)/, use_prefix: false
      
  def execute(m, url_part)
    m.reply status(url_part)
  end

  private
  def status(url_part)
    html = WebPage.load_html("https://twitter.com/#{url_part}")
    tweet = html.css('.permalink-inner .tweet-text')[0].text
    tweet.gsub("\n", ' ')
  rescue OpenURI::HTTPError
    'Not found'
  end
end
