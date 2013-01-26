require 'cgi'
require_relative '../utils/webpage'


class Google
  include Cinch::Plugin

  match /g(?:oogle)? (.+)/

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
