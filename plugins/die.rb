#encoding: utf-8
require 'cinch'


class Die
    include Cinch::Plugin

    match 'd'

    def execute(m)
        m.target.action('se s vámi loučí')
        @bot.quit()
    end
end
