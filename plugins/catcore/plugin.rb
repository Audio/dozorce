module Catcore

  class Plugin
    include Cinch::Plugin

    set :help, 'catcore - prints a random catcore commit message'

    match /catcore$/

    def initialize(*args)
      super
      @commitmsgs=[]  # start with an empty array
      f = File.open(File.join(File.dirname(File.expand_path(__FILE__))) + "/commit_messages.txt")
      f.each_line {|line|
        @commitmsgs.push line
      }
      @commitmsgs.shuffle!
      f.close
    end

    def execute(m)
      m.reply(@commitmsgs[rand(@commitmsgs.count)])
    end
  end
end

