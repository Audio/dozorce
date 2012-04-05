require 'cinch'


class Die
    include Cinch::Plugin

    @prefix = ''

    match 'chcipni'

    def execute(m)
        @bot.quit()
    end
end
