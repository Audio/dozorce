#encoding: utf-8
require 'cinch'


class Die
    include Cinch::Plugin

    match 'chcipni', use_prefix: false

    def execute(m)
        m.target.action('chcípá')
        @bot.quit()
    end
end
