require 'json'
require 'net/https'
require 'nokogiri'
require 'open-uri'


class WebPage
  def self.load_plain(url)
    self.load(url).string
  end

  def self.load_html(url)
    Nokogiri::HTML.parse( self.load(url) )
  end

  def self.load_xml(url)
    Nokogiri::XML( self.load(url) )
  end

  def self.load_json(url, &block)
    str = self.load(url).string
    str = yield str if block_given?
    JSON.parse(str, {:symbolize_names => true})
  end

  def self.load_and_read_json(url, &block)
    str = self.load(url).read
    str = yield str if block_given?
    JSON.parse(str, {:symbolize_names => true})
  end

  private
  def self.load(url)
    f = open(url,
             :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
             "User-Agent" => "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.56 Safari/537.17"
    )

    type = f.content_type
    if !type.nil? and !type.start_with?("text/") and !type.start_with?("application/")
      raise "Bad content-type: #{type}"
    end

    f
  end
end
