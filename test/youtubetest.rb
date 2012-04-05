$LOAD_PATH << 'plugins'

require 'youtube'


class YoutubeTest < TestCase
    # TODO directly use Youtube class
    #@fake_bot = Cinch::Bot.new
    #@youtube = Youtube.new(@fake_bot)

    test "Long URLs regex matching" do
        reg_long = /youtube\.com.*v=([^&$]{11})(&| |$)/

        assert_match(reg_long, 'http://www.youtube.com/watch?v=8WVTOUh53QY');
        assert_match(reg_long, 'http://www.youtube.com/watch?user=troub&v=8WVTOUh53QY&feature=feedf');
        refute_match(reg_long, 'http://www.youtube.com/watch?user=troub&v=8WVTOUh53QAY&feature=feedf');
        refute_match(reg_long, 'http://www.youtube.com/omgaaaaaaaa&v=');
    end

    test "Short URLs regex matching" do
        reg_short = /youtu\.be\/([^&\?$]{11})(&| |$)/

        assert_match(reg_short, 'http://youtu.be/8WVTOUh53QY');
        assert_match(reg_short, 'http://youtu.be/8WVTOUh53QY&feature=feedf');
        refute_match(reg_short, 'http://youtu.be/8WVTOUh53Q&feature=feedf');
        refute_match(reg_short, 'http://youtu.be/8WVTa?Uh53Q&feature=feedf');
        refute_match(reg_short, 'http://youtu.be/8WVTaJJJJJUh53Q&feature=feedf');
    end
end
