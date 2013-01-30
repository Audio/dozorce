#encoding: utf-8


class Die
  include Cinch::Plugin

  set :help, 'die - the bot will immediately quit'

  match 'd'

  def execute(m)
    m.target.action('se s vámi loučí')
    @bot.quit()
  end
end
