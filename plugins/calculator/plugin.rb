
require_relative '../../utils/webpage'
require_relative './services/googlefinance'
require_relative './services/wolframalpha'
require_relative './config'


module Calculator

  class Plugin
    include Cinch::Plugin

    set :help, 'c [formula] - calculates the formula. Example: c (5 + 6) / 2'

    def initialize(*args)
      super
      @config = Config
      @google = Services::GoogleFinance.new(Config, WebPage)
      @wolfram = Services::WolframAlpha.new(Config, WebPage)
    end

    match Config[:routes][:standard_prefix]
    def execute(m, query)
      m.reply(@wolfram.convert query)
    end

    match Config[:routes][:symbol_prefix], use_prefix: false, method: :convert_symbol_prefix
    def convert_symbol_prefix(m, symbol, amount)
      currency = @config[:symbols].key symbol
      reply_converted_currency m, amount, currency.to_s unless currency.nil?
    end

    match Config[:routes][:symbol_postfix], use_prefix: false, method: :convert_symbol_postfix
    def convert_symbol_postfix(m, amount, symbol)
      convert_symbol_prefix m, symbol, amount
    end

    match Config[:routes][:converter_long], use_prefix: false, method: :convert_long
    def convert_long(m, amount, from, to)
      reply_converted_currency m, amount, from, to
    end

    match Config[:routes][:converted_short], use_prefix: false, method: :convert_short
    def convert_short(m, amount, from)
      reply_converted_currency m, amount, from if @config[:from].include? from
    end

    private
    def reply_converted_currency(m, amount, from, to = nil)
      m.reply(@google.convert amount, from, to)
    end
  end

end
