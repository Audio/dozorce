#encoding: utf-8
require 'stringio'


class Eval
  include Cinch::Plugin

  match /^.rb +(.+)/, use_prefix: false

  def execute(m, code)
    sio = StringIO.new
    old_stdout, $stdout = $stdout, sio
    $SAFE = 2
    begin
      eval(code)
      result = sio.string[0..400]
    rescue SecurityError
      result = 'vypadam jako debil, co by spustil skodlivej kod?'
    end
    $stdout = old_stdout

    if result.empty?
      result = 'kde nic, tu nic'
    end
    m.reply("#{m.user.nick}: #{result}")
  end
end
