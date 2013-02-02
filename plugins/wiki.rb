require 'cgi'
require_relative '../utils/webpage'


class Wiki
  include Cinch::Plugin

  set :help, 'wik(i)(-[lang]) [query] - returns the first result via MediaWiki. Example: wik-en hamster'

  match /wiki?(?:-(.{2}))? (.+)/

  def initialize(*args)
    super
    @def_lang = "en"
  end

  def execute(m, lang, query)
    m.reply( search(lang, query), true)
  end

  def search(lang, query)
    lang = @def_lang if lang.nil?

    result = result(lang, query)
    if result.nil?
      search_url = "http://#{lang}.wikipedia.org/w/api.php?action=opensearch&search=#{CGI.escape(query)}&limit=1&namespace=0&format=json"
      json_search = WebPage.load_json(search_url)
      search_result = json_search[1][0]
      result = result(lang, search_result)
    end

    raise Exception if result.nil?

    "#{first_sentense_of result} - http://#{lang}.wikipedia.org/wiki/#{query}"
  rescue Exception
    "No result"
  end

  def result(lang, query)
    url = "http://#{lang}.wikipedia.org/wiki/#{CGI.escape(query)}"
    doc = WebPage.load_html(url)
    doc.xpath("//div[@id='bodyContent']/div/p[1]").text
  end

  def first_sentense_of(string)
    string = remove_references string
    sentenses = string.split '. '
    result = "#{sentenses.shift}. "
    while sentenses.size > 0
      next_sentense = sentenses.shift
      break if next_sentense.strip.match /^[A-Z]/
      result << next_sentense << '. '
    end

    result
  end

  def remove_references(string)
    string.gsub(/\[[\d]{1,2}\]/, '')
  end
end
