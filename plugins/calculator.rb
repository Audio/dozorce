require 'cgi'
require_relative '../utils/webpage'


class Calculator
  include Cinch::Plugin

  set :help, 'c [formula] - calculates the formula. Example: c (5 + 6) / 2'

  float_num = /\d+(?:(?:\.|,)\d+)?/
  unit = /[a-zA-Z]+/
  match /c +(.+)/
  match /^(#{float_num} +#{unit} +to +#{unit})$/, use_prefix: false, method: :currency_execute
  match /^(#{float_num}) +(#{unit})$/, use_prefix: false, method: :currency_shortcut
  match /^(\S) *(#{float_num})$/, use_prefix: false, method: :currency_symbol_amount
  match /^(#{float_num}) *(\S)$/, use_prefix: false, method: :currency_amount_symbol

  @@appid = "9U7YJH-GJAQRRH92L"

  class << self
    attr_accessor :currency_shortcut

    def configure(&block)
      yield self
    end
  end

  def initialize(*args)
    super
    @currency = self.class.currency_shortcut
  end

  def execute(m, query)
    m.reply(calc query)
  end

  def calc(query)
    url = "http://api.wolframalpha.com/v2/query?appid=#{@@appid}&input=#{CGI.escape(query)}&format=plaintext"
    pods = WebPage.load_xml(url).xpath("queryresult/pod")
    "#{pods[1]["title"]}: #{pods[1].xpath("subpod/plaintext").first.content}"
  end

  def currency_handle(m, amount, from, to)
    m.reply(currency_calc(amount, from, to))
  end

  def currency_execute(m, query)
    params = currency_array(query)
    currency_handle(m, params[1], params[2], params[3])
  end

  def execute_shortcut(m, amount, currency)
    currency_handle(m, amount.to_s, currency.to_s, @currency[:to])
  end

  def currency_shortcut(m, amount, currency)
    execute_shortcut(m, amount, currency) if @currency[:from].include? currency
  end

  def currency_symbol_amount(m, symbol, amount)
    currency = @currency[:symbols].key(symbol)
    execute_shortcut(m, amount, currency) unless currency.nil?
  end

  def currency_amount_symbol(m, amount, symbol)
    currency_symbol_amount(m, symbol, amount)
  end

  def currency_array(query)
    query.match /(\d+) (\w{0,4}) to (\w{2,4})/
  end

  def currency_calc(amount, from, to)
    url = "https://www.google.com/finance/converter?a=#{CGI.escape(amount)}&from=#{CGI.escape(from)}&to=#{CGI.escape(to)}"
    doc = WebPage.load_html(url)
    doc.css("div#currency_converter_result").text
  end
end
