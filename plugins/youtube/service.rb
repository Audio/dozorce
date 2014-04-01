
class YoutubeService
  def initialize(webpage)
    @webpage = webpage
  end

  def fetch_title(video_id)
    begin
      doc = @webpage.load_xml("http://gdata.youtube.com/feeds/api/videos/#{video_id}")
      doc.xpath('//media:title').first.content
    rescue OpenURI::HTTPError => e
      "Unavailable video (server returned #{e.message})"
    end
  end
end
