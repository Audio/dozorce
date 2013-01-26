require_relative '../utils/webpage'


class Title
  include Cinch::Plugin

  match /t +(http.+)/

  def execute(m, url)
    m.reply( WebPage.load_html(url).title )
  end
end
