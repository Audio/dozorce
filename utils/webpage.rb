require 'nokogiri'
require 'open-uri'
require 'net/https'


class WebPage
    attr_reader :type, :title, :content

    def initialize(url)
        open(url,
          :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
          "User-Agent" => "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.142 Safari/535.19"
          ) {|f|

            @type = f.content_type
            if @type != nil and !@type.start_with?("text/") and !@type.start_with?("application/xhtml")
                raise "Bad content-type: " + @type
            end

            @content = Nokogiri::HTML.parse(f)
            @title = @content.title

        }
    end
end
