
require 'cgi'


module Calculator
  module Services

    class WolframAlpha
      def initialize(config, webpage)
        @config = config
        @webpage = webpage
      end

      def convert(query)
        begin
          url = "http://api.wolframalpha.com/v2/query?appid=#{@config[:app_id]}&input=#{CGI.escape(query)}&format=plaintext"
          pods = @webpage.load_xml(url).xpath('queryresult/pod')
          "#{pods[1]["title"]}: #{pods[1].xpath("subpod/plaintext").first.content}"
        rescue OpenURI::HTTPError => e
          "Conversion failed (#{e.message})"
        end
      end
    end

  end
end
