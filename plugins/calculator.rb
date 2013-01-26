require 'cgi'
require 'open-uri'


class Calculator
  include Cinch::Plugin

  match /c +(.+)/
  match /^(\d+(?:(?:\.|,)\d+)? +[a-zA-Z]+ +to +[a-zA-Z]+)$/, use_prefix: false

  def execute(m, query)
    m.reply(calc query)
  end

  def calc(query)
    io = open("http://www.google.com/ig/calculator?hl=en&q=#{CGI.escape(query)}")
    parse(io.string)
  end

  def parse(json)
    p = json.split(",")
    (p[2].split("\"").length > 1) ? "Incorrect syntax." : p[0].split("\"")[1] + " = " + p[1].split("\"")[1]
  end
end
