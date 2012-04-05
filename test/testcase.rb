require 'minitest/autorun'


class TestCase < MiniTest::Unit::TestCase
  def self.test(name, &block)
    define_method("test_" + name, &block) if block
  end
end
