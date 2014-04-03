
module Calculator
  module Services

    class GoogleFinance
      def initialize(config, webpage)
        @config = config
        @webpage = webpage
      end

      def convert(amount, from, to = nil)
        amount = amount.to_s # could be number
        to = @config[:to] if to.nil?

        begin
          url = "https://www.google.com/finance/converter?a=#{CGI.escape(amount)}&from=#{CGI.escape(from)}&to=#{CGI.escape(to)}"
          doc = WebPage.load_html(url)
          result = doc.css("div#currency_converter_result").text.strip
          result = 'Conversion failed' if result.empty?
          result
        rescue OpenURI::HTTPError => e
          "Conversion failed (#{e.message})"
        end
      end
    end

  end
end
