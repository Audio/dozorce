
module Youtube
  module Services

    class Youtube
      def initialize(webpage)
        @webpage = webpage
      end

      def fetch_title(video_id)
        begin
          doc = @webpage.load_html "https://www.youtube.com/watch?v=#{video_id}"
          meta = doc.at('meta[property="og:title"]')

          # YT can respond with 200 OK on unknown video id
          raise OpenURI::HTTPError.new('404 Not Found', nil) unless meta

          meta['content']
        rescue OpenURI::HTTPError => e
          "Unavailable video (server returned #{e.message})"
        end
      end
    end

  end
end
