# Dozorce - Ruby IRC bot

Dozorce is a collection of plugins for the [Cinch](https://github.com/cinchrb/cinch) IRC bot written in Ruby.

[![Build Status](https://travis-ci.org/Audio/dozorce.png?branch=master)](https://travis-ci.org/Audio/dozorce)
[![volkswagen status](https://auchenberg.github.io/volkswagen/volkswargen_ci.svg?v=1)](https://github.com/auchenberg/volkswagen)

## Installation
You can use `bundle` to install required ruby gems:

    sudo bundle install


## Usage
See installation steps and usage instructions on the [cinch project page](https://github.com/cinchrb/cinch/blob/master/README.md).


## Plugins
In the following examples, the plugin prefix is set by default to ```!```


### Bash
Prints a random quote from bash.org database.

Usage:
```
!bash
```


### Calculator
Calculates given formula.

Usages:
```
!c [formula]
```
```
[number] [unit1] to [unit2]
```
```
[number] [predefined-currency]
```
```
[number] [predefined-symbol]
```

Examples:
```
!c (5 + 6) / 2
```
```
18 stones to kg
```
```
18 usd
17 €
$11
```

Config:
```
Calculator.configure do |c|
  c.currency_shortcut = {
      :to   => 'czk',
      :from => %w(usd eur euro euros),
      :symbols => {
          :usd   => '$',
          :eur   => '€',
          :pound => '£'
      }
  }
end
```


### Csfd
Returns info about queried movie.

Usage:
```
!csfd [query]
```

Example:
```
!csfd star wars xxx a porn parody
```


### Google
Returns the first result via Google Search.

Usage:
```
!go [query]
```

Examples:
```
!go cinema in Prague
```


### Help
Prints information about a command (or all commands with no name specified).

Usage:
```
!help [name]
```

Examples:
```
!help
```
```
!help calculator
```


### Rejoin
If the bot is kicked, it will attempt to rejoin after 10 seconds by default.


### RSS
Prints the list of monitored feeds. Plugin prints new messages automatically in a short interval.
Feeds list can be set via plugin's config.

Usage:
```
!rss list
```

Config:
```
Rss.configure do |c|
  c.feeds = {
      :bashoid => 'https://github.com/Audio/bashoid/commits/master.atom',
      :dozorce => 'https://github.com/Audio/dozorce/commits/master.atom'
  }
end
```


### Title
Prints the title of a page specified in parameter.

Usage:
```
!t [url]
```

Example:
```
!t http://www.seznam.cz/
```


### Track
Prints all tracked users. Plugin prints new ratings automatically in a short interval.

Usage:
```
!track list
```


### Translator
Translates the query string. Lang parameters are optional for the first pattern.

Usages:
```
!tr [source-lang]-[to-lang] [query]
```
```
!tr [query]
```

Examples:
```
!tr en-cs dog
```
```
!tr dog
```


### Twitter
Twitter plugin automatically prints tweets from detected URLs.


### Wiki
Returns the first result via MediaWiki.

Usage:
```
!wik(i)(-[lang]) [query]
```

Example:
```
!wik-en hamster
```


### YouTube
YouTube plugin automatically prints video titles from detected URLs.
