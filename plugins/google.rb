require 'cgi'
require_relative '../utils/webpage'


class Google
  include Cinch::Plugin

  set :help, 'go [query] - returns the first result via Google Search. Example: go cinema in Prague'

  match /go (.+)/

  def execute(m, query)
    m.reply( search(query), true)
  end

  def search(query)
    url = "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&safe=off&q=#{CGI.escape(query)}"
    json = WebPage.load_json(url)
    result = json[:responseData][:results][0]
    CGI.unescapeHTML "#{result[:unescapedUrl]} #{result[:titleNoFormatting]}"
  rescue
    "No result"
  end
end
