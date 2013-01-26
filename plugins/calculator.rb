require 'cgi'
require_relative '../utils/webpage'


class Calculator
  include Cinch::Plugin

  match /c +(.+)/
  match /^(\d+(?:(?:\.|,)\d+)? +[a-zA-Z]+ +to +[a-zA-Z]+)$/, use_prefix: false

  def execute(m, query)
    m.reply(calc query)
  end

  def calc(query)
    json = WebPage.load_plain("http://www.google.com/ig/calculator?hl=en&q=#{CGI.escape(query)}")
    parse(json)
  end

  def parse(json)
    p = json.split(",")
    (p[2].split("\"").length > 1) ? "Incorrect syntax." : p[0].split("\"")[1] + " = " + p[1].split("\"")[1]
  end
end
