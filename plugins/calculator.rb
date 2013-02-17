require 'cgi'
require_relative '../utils/webpage'


class Calculator
  include Cinch::Plugin

  set :help, 'c [formula] - calculates the formula. Example: c (5 + 6) / 2'

  float_num = /\d+(?:(?:\.|,)\d+)?/
  unit = /[a-zA-Z]+/
  match /c +(.+)/
  match /^(#{float_num} +#{unit} +to +#{unit})$/, use_prefix: false
  match /^(#{float_num}) +(#{unit})$/, use_prefix: false, method: :currency_shortcut
  match /^(\S) *(#{float_num})$/, use_prefix: false, method: :currency_symbol_amount
  match /^(#{float_num}) *(\S)$/, use_prefix: false, method: :currency_amount_symbol

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

  def execute_shortcut(m, amount, currency)
    execute(m, "#{amount} #{currency} to #{@currency[:to]}")
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

  def calc(query)
    url = "http://www.google.com/ig/calculator?hl=cs&q=#{CGI.escape(query)}"
    json = WebPage.load_json(url) { |str| str.gsub(/(\w+): /, '"\1":') }
    json[:error].length > 1 ? "No result" : json[:rhs]
  end
end
