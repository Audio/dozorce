require_relative '../utils/webpage'


class Title
  include Cinch::Plugin

  set :help, 't [url] - prints the title of a page specified in parameter. Example: t http://www.seznam.cz/'

  match /t +(http\S+)/

  def execute(m, url)
    m.reply( WebPage.load_html(url).title.strip )
  end
end
