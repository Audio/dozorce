require 'cgi'
require_relative '../utils/webpage'


class Translator
  include Cinch::Plugin

  # cs en "dog"? / cs to en "dog"? / "dog"?
  match /(?:(\w{2,5}) +(?:to)? *(\w{2,5}) +)?"(.+)"\?/, use_prefix: false

  # en to cz dog
  match /(\w{2,5}) +to +(\w{2,5}) +(.+)/, use_prefix: false

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
