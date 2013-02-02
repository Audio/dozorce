require 'cgi'
require_relative '../utils/webpage'


class Translator
  include Cinch::Plugin

  set :help, 'tr [source-lang]-[to-lang] [query] - translates the query string. Lang parameters are optional. Example: tr en-cs dog OR tr dog'

  match /tr (?:(\w{2})-(\w{2}) )?(.+)/

  def execute(m, lang_from, lang_to, text)
    m.reply( translate(text, lang_from, lang_to), true)
  end

  def translate(text, from, to)
    from = "auto" if from.nil?
    to = "cs" if to.nil? || to == "cz"

    url =  "http://translate.google.com/translate_a/t?client=t&hl=cs&sl=#{from}&tl=#{to}"
    url << "&multires=1&otf=1&ssel=0&tsel=0&uptl=en&sc=1&text=#{CGI.escape(text)}"
    json = WebPage.load_json(url) { |str|
      str.gsub!(',,', ',null,') while str.include?(',,')
      str
    }

    if json[1].nil? || json[1][0].nil?
      json[0][0][0]
    else
      json[1][0][1].join(', ')
    end
  rescue
    "No result"
  end
end
