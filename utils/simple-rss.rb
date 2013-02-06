#
# (c) https://github.com/cardmagic/simple-rss
# inludes custom speed modifications (loads titles and links only)
#
require 'cgi'
require 'time'

class SimpleRSS
  attr_reader :items

  def initialize(source, options={})
    @source = source.respond_to?(:read) ? source.read : source.to_s
    @items = Array.new
    @options = Hash.new.update(options)
    @tags = [ :title, :link ]

    parse
  end

  def self.parse(source, options={})
    new(source, options)
  end

  private
  def parse
    raise SimpleRSSError, "Poorly formatted feed" unless @source =~ %r{<(channel|feed).*?>.*?</(channel|feed)>}mi

    # Feed's title and link
    feed_content = $1 if @source =~ %r{(.*?)<(rss:|atom:)?(item|entry).*?>.*?</(rss:|atom:)?(item|entry)>}mi

    @tags.each do |tag|
      if feed_content && feed_content =~ %r{<(rss:|atom:)?#{tag}(.*?)>(.*?)</(rss:|atom:)?#{tag}>}mi
        nil
      elsif feed_content && feed_content =~ %r{<(rss:|atom:)?#{tag}(.*?)\/\s*>}mi
        nil
      elsif @source =~ %r{<(rss:|atom:)?#{tag}(.*?)>(.*?)</(rss:|atom:)?#{tag}>}mi
        nil
      elsif @source =~ %r{<(rss:|atom:)?#{tag}(.*?)\/\s*>}mi
        nil
      end

      if $2 || $3
        tag_cleaned = clean_tag(tag)
        instance_variable_set("@#{ tag_cleaned }", clean_content(tag, $2, $3))
        self.class.send(:attr_reader, tag_cleaned)
      end
    end

    # RSS items' title, link, and description
    @source.scan(%r{<(rss:|atom:)?(item|entry)([\s][^>]*)?>(.*?)</(rss:|atom:)?(item|entry)>}mi) do |match|
      item = Hash.new
      @tags.each do |tag|
        if tag.to_s.include?("+")
          tag_data = tag.to_s.split("+")
          tag = tag_data[0]
          rel = tag_data[1]

          if match[3] =~ %r{<(rss:|atom:)?#{tag}(.*?)rel=['"]#{rel}['"](.*?)>(.*?)</(rss:|atom:)?#{tag}>}mi
            nil
          elsif match[3] =~ %r{<(rss:|atom:)?#{tag}(.*?)rel=['"]#{rel}['"](.*?)/\s*>}mi
            nil
          end
          item[clean_tag("#{tag}+#{rel}")] = clean_content(tag, $3, $4) if $3 || $4
        elsif tag.to_s.include?("#")
          tag_data = tag.to_s.split("#")
          tag = tag_data[0]
          attrib = tag_data[1]
          if match[3] =~ %r{<(rss:|atom:)?#{tag}(.*?)#{attrib}=['"](.*?)['"](.*?)>(.*?)</(rss:|atom:)?#{tag}>}mi
            nil
          elsif match[3] =~ %r{<(rss:|atom:)?#{tag}(.*?)#{attrib}=['"](.*?)['"](.*?)/\s*>}mi
            nil
          end
          item[clean_tag("#{tag}_#{attrib}")] = clean_content(tag, attrib, $3) if $3
        else
          if match[3] =~ %r{<(rss:|atom:)?#{tag}(.*?)>(.*?)</(rss:|atom:)?#{tag}>}mi
            nil
          elsif match[3] =~ %r{<(rss:|atom:)?#{tag}(.*?)/\s*>}mi
            nil
          end
          item[clean_tag(tag)] = clean_content(tag, $2, $3) if $2 || $3
        end
      end

      def item.method_missing(name, *args)
        self[name]
      end

      @items << item
    end

  end

  def clean_content(tag, attrs, content)
    content = content.to_s
    content.empty? && "#{attrs} " =~ /href=['"]?([^'"]*)['" ]/mi ? $1.strip : unescape(content)
  end

  def clean_tag(tag)
    tag.to_s.gsub(':', '_').intern
  end

  def unescape(content)
    if content =~ /([^-_.!~*'()a-zA-Z\d;\/?:@&=+$,\[\]]%)/u then
      CGI.unescape(content).gsub(/(<!\[CDATA\[|\]\]>)/u, '').strip
    else
      content.gsub(/(<!\[CDATA\[|\]\]>)/u, '').strip
    end
  end
end

class SimpleRSSError < StandardError
end
