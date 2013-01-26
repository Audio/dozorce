require 'cgi'
require 'json'
require 'open-uri'


class Google
  include Cinch::Plugin

  match /g(?:oogle)? (.+)/

  def execute(m, query)
    m.reply( search(query), true)
  end

  def search(query)
    io = open("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&safe=off&q=#{CGI.escape(query)}")
    result = JSON.parse(io.string, {:symbolize_names => true})[:responseData][:results][0]
    CGI.unescapeHTML "#{result[:unescapedUrl]} #{result[:titleNoFormatting]}"
  rescue
    "No result"
  end
end
