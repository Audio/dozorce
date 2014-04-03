#encoding: utf-8

require 'cinch'
require_relative '../utils/webpage'
require_relative '../plugins/calculator/services/googlefinance'
require_relative '../plugins/calculator/services/wolframalpha'
require_relative '../plugins/calculator/config'


=begin
describe Calculator::Config do
  before :all do
    @routes = Calculator::Config[:routes]
  end

  it 'should match standard prefix' do
    'c 1 + 1'.should match @routes[:standard_prefix]
  end

  it 'should match symbol prefix' do
    '$12'.should match @routes[:symbol_prefix]
  end

  it 'should match symbol postfix' do
    '12 €'.should match @routes[:symbol_postfix]
    '12 £'.should match @routes[:symbol_postfix]
  end

  it 'should match long converter pattern' do
    '12 stones to kilograms'.should match @routes[:converter_long]
  end

  it 'should match short converter pattern' do
    '12 usd'.should match @routes[:converted_short]
  end

  it 'should not match nonsense convertions' do
    '12 usd to czk to eur to usd'.should_not match @routes[:converter_long]
  end
end


describe Calculator::Services::WolframAlpha do
  before(:all) do
    @instance = Calculator::Services::WolframAlpha.new(Calculator::Config, WebPage)
  end

  it 'should convert distance units' do
    result = @instance.convert '0.00000001 au to km'
    expect(result).to eq('Result: 1.5 km  (kilometers)')
  end

  it 'should convert temperature units' do
    result = @instance.convert '33.8 f to c'
    expect(result).to eq('Result: 1 °C  (degree Celsius)')
  end

  it 'should not convert different units' do
    result = @instance.convert '33.8 f to kilograms'
    expect(result).to eq('Result:  °F  (degrees Fahrenheit) and  kg  (kilograms) are not compatible.')
  end

  it 'should do calculations' do
    result = @instance.convert '9 + 9 * 3'
    expect(result).to eq('Result: 36')
  end
end
=end

describe Calculator::Services::GoogleFinance do
  before(:all) do
    @instance = Calculator::Services::GoogleFinance.new(Calculator::Config, WebPage)
    @result_pattern = /^12 USD = [0-9\.]+ CZK$/
  end

  it 'should convert currencies' do
    amount = 12
    from = 'usd'
    to = 'czk'

    result = @instance.convert amount, from, to
    expect(result).to match @result_pattern
  end

  it 'should convert amount to default currency' do
    amount = 12
    from = 'usd'

    result = @instance.convert amount, from
    expect(result).to match @result_pattern
  end

  it 'should accept string amount' do
    amount = '12'
    from = 'usd'
    to = 'czk'

    result = @instance.convert amount, from, to
    expect(result).to match @result_pattern
  end

  it 'should not do nonsense conversions' do
    amount = 12
    from = 'usd'
    to = 'kilograms'

    result = @instance.convert amount, from, to
    expect(result).to eq 'Conversion failed'
  end
end
