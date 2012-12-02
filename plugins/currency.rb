require 'open-uri'
require 'uri'


class Currency
  include Cinch::Plugin

  match /^\d+ +[a-zA-Z]+ +to +[a-zA-Z]+$/, use_prefix: false

  def execute(m)
    m.reply(calc m.message)
  end

  def calc(query)
    io = open("http://www.google.com/ig/calculator?hl=en&q=" + URI.escape(query))
    return parse(io.string)
  end

  def parse(json)
    p = json.split(",")
    return (p[2].split("\"").length > 1) ? "Asi incorrect syntax nebo co." : p[0].split("\"")[1] + " = " + p[1].split("\"")[1]
  end
end
