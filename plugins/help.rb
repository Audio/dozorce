class Help
  include Cinch::Plugin

  set :help, 'help [name] - prints information about a command (or all commands with no name specified). Example: help calculator'

  match /help (\w+)/, method: :with_name
  match /help$/, method: :without_name

  def with_name(m, query)
    active, help_available = false
    @bot.plugins.find { |plugin|
      if plugin.class.plugin_name == query
        active = true
        help_available = !plugin.class.help.nil?
      end
    }
    unless active && help_available
      result = active ? 'No help available.' : 'No active plugin. Type help for list of available plugins.'
      m.reply result
    end
  end

  def without_name(m)
    plugin_names = []
    @bot.plugins.each { |plugin| plugin_names << plugin.class.plugin_name }
    m.reply "Active plugins: #{plugin_names.join(', ')}"
  end
end
