# Dozorce - Ruby IRC bot

Dozorce is a collection of plugins for the [Cinch](https://github.com/cinchrb/cinch) IRC bot written in Ruby.


## Usage
See installation steps and usage instructions on the [cinch project page](https://github.com/cinchrb/cinch/blob/master/README.md).


## Plugins
[suppose the global plugin prefix is not set]


### Bash
Prints a random quote from bash.org database.

Usage:
```
bash
```


### Calculator
Calculates given formula.

Usages:
```
c [formula]
```
```
[number] [unit1] to [unit2]
```

Examples:
```
c (5 + 6) / 2
```
```
18 stones to kg
```


### Csfd
Returns info about queried movie.

Usage:
```
csfd [query]
```

Example:
```
csfd star wars xxx a porn parody
```


### Google
Returns the first result via Google Search.

Usage:
```
go [query]
```

Examples:
```
go cinema in Prague
```


### Help
Prints information about a command (or all commands with no name specified).

Usage:
```
help [name]
```

Examples:
```
help
```
```
help calculator
```


### RSS
Prints the list of monitored feeds. Plugin prints new messages automatically in a short interval.
Feeds list can be set via plugin's config.

Usage:
```
rss list
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
t [url]
```

Example:
```
t http://www.seznam.cz/
```


### Translator
Translates the query string. Lang parameters are optional for the first pattern.

Usages:
```
tr [source-lang]-[to-lang] [query]
```
```
tr [query]
```

Examples:
```
tr en-cs dog
```
```
tr dog
```


### Twitter
Prints the user status. Plugin also works automatically for detected Twitter URLs.

Usage:
```
tw [status]
```

Example:
```
tw 297374318562779137
```


### Wiki
Returns the first result via MediaWiki.

Usage:
```
wik(i)(-[lang]) [query]
```

Example:
```
wik-en hamster
```


### YouTube
YouTube plugin automatically prints video titles from detected URLs.
