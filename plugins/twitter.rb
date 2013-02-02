require_relative '../utils/webpage'


class Twitter
  include Cinch::Plugin

  set :help, 'tw [status] - prints the status. Plugin also works automatically for Twitter URLs. Example: tw 297374318562779137'

  match /twitter.com\/\w*\/status\/(\d+)/, use_prefix: false
  match /tw(?:itter\.com)? +(\d+)$/
      
  def execute(m, status_id)
    m.reply status(status_id)
  end

  private
  def status(status_id)
    tweet = WebPage.load_json("https://api.twitter.com/1/statuses/show/#{status_id}.json")
    "@#{tweet[:user][:screen_name]}: #{tweet[:text].gsub("\n", ' ')}"
  end
end
