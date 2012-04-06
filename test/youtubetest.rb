$LOAD_PATH << 'plugins'

require 'youtube'


class YoutubeTest < TestCase
    def initialize(name)
        super(name)
        youtube = Youtube.new(@bot)
        @reg_long = youtube.reg_long
        @reg_short = youtube.reg_short
    end

    test "Long URLs regex matching" do
        assert_match(@reg_long, 'http://www.youtube.com/watch?v=8WVTOUh53QY')
        assert_match(@reg_long, 'http://www.youtube.com/watch?user=troub&v=8WVTOUh53QY&feature=feedf')
        refute_match(@reg_long, 'http://www.youtube.com/watch?user=troub&v=8WVTOUh53QAY&feature=feedf')
        refute_match(@reg_long, 'http://www.youtube.com/omgaaaaaaaa&v=')
    end

    test "Short URLs regex matching" do
        assert_match(@reg_short, 'http://youtu.be/8WVTOUh53QY')
        assert_match(@reg_short, 'http://youtu.be/8WVTOUh53QY&feature=feedf')
        refute_match(@reg_short, 'http://youtu.be/8WVTOUh53Q&feature=feedf')
        refute_match(@reg_short, 'http://youtu.be/8WVTa?Uh53Q&feature=feedf')
        refute_match(@reg_short, 'http://youtu.be/8WVTaJJJJJUh53Q&feature=feedf')
    end
end
