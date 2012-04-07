require 'cinch'
require 'nokogiri'
require 'open-uri'
require 'net/https'


class Title
    include Cinch::Plugin

    match /^t +(http.+)/, use_prefix: false

    def execute(m, url)
        m.reply( title(url) )
    end

    def title(url)
        begin
            open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) { |f|

                type = f.content_type
                if type != nil and !type.start_with?("text/") and !type.start_with?("application/xhtml")
                    raise "Bad content-type: " + type
                end

                # t = (t == nil) ? "Sorry bro, no title found" : t
                return Nokogiri::HTML.parse(f).title

            }
        rescue
            return "Invalid URL or resource content type"
        end
    end
end
