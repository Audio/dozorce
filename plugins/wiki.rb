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
      json_search = WebPage.load_and_read_json(search_url)
      search_result = json_search[1][0]
      result = result(lang, search_result)
    end

    raise Exception if result.nil?

    result_content = result[:revisions][0][:*]
    result_line = result_content[/\n('{3}(\[{2})?)?[A-Z].[^\.:]*:?/]
    last_char = result_line[-1,1]
    result_line = result_content[/\* .+/] if last_char == ":"

    result_line.gsub!(/(\[.*\|)|[\[\]']|(\* )/, "")
    "#{result_line.strip} - http://#{lang}.wikipedia.org/wiki/#{result[:title]}"
  rescue Exception => e
    "No result"
  end

  def result(lang, query)
    url = "http://#{lang}.wikipedia.org/w/api.php?action=query&titles=#{CGI.escape(query)}&prop=revisions&rvprop=content&format=json"
    json_exact = WebPage.load_and_read_json(url)
    results = json_exact[:query][:pages]
    pageid = results.keys[0]
    pageid == :"-1" ? nil : results[pageid]
  end
end
