require 'minitest/autorun'


class TestCase < MiniTest::Unit::TestCase
    def initialize(name)
        super(name)
        @bot = Cinch::Bot.new
        @bot.loggers.level = :error
    end

    def self.test(name, &block)
        define_method("test_" + name, &block) if block
    end
end

