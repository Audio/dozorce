require 'cgi'
require_relative '../utils/webpage'


class Calculator
  include Cinch::Plugin

  set :help, 'c [formula] - calculates the formula. Example: c (5 + 6) / 2'

  match /c +(.+)/
  match /^(\d+(?:(?:\.|,)\d+)? +[a-zA-Z]+ +to +[a-zA-Z]+)$/, use_prefix: false

  def execute(m, query)
    m.reply(calc query)
  end

  def calc(query)
    url = "http://www.google.com/ig/calculator?hl=cs&q=#{CGI.escape(query)}"
    json = WebPage.load_json(url) { |str| str.gsub(/(\w+): /, '"\1":') }
    json[:error].length > 1 ? "No result" : "#{json[:lhs]} = #{json[:rhs]}"
  end
end
