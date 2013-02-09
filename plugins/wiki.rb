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
    escaped_query = escape query

    search_url = "http://#{lang}.wikipedia.org/w/api.php?action=opensearch&search=#{escaped_query}&limit=1&namespace=0&format=json"
    query = WebPage.load_json(search_url)[1][0]

    if query.nil?
      "No result"
    else
      escaped_query = escape query
      result = result(lang, escaped_query)
      "#{first_sentense_of result} - http://#{lang}.wikipedia.org/wiki/#{escaped_query}"
    end
  end

  def escape(query)
    CGI.escape query.gsub(' ', '_')
  end

  def result(lang, escaped_query)
    url = "http://#{lang}.wikipedia.org/wiki/#{escaped_query}"
    doc = WebPage.load_html(url)
    doc.xpath("//div[@id='bodyContent']/div/p[1]").text
  end

  def first_sentense_of(string)
    remove_references!(string)
    sentenses = string.split '. '
    result = "#{sentenses.shift}. "
    while sentenses.size > 0
      next_sentense = sentenses.shift
      break if next_sentense.strip.match /^[A-Z]/
      result << next_sentense << '. '
    end

    result
  end

  def remove_references!(string)
    string.gsub!(/\[[\d]{1,2}\]/, '')
  end
end
