# Dozorce - Ruby IRC bot

Dozorce is a collection of plugins for the [Cinch](https://github.com/cinchrb/cinch) IRC bot written in Ruby.


## Usage
See installation steps and usage instructions on the [cinch project page](https://github.com/cinchrb/cinch/blob/master/README.md).


## Plugins
[suppose that the global plugin prefix is off]


### Bash
Prints a random quote from bash.org database.

Usage: ```bash```


### Calculator
Calculates given formula.

Usage: ```c [formula]``` or ```[number] [unit1] to [unit2]```

Example: ```c (5 + 6) / 2``` or ```18 stones to kg```


### Csfd
Returns info about queried movie.

Usage: ```csfd [query]```

Example: ```csfd star wars xxx a porn parody```


### Eval
Evaluates given ruby expression.

Usage: ```rb [expr]```

Example: ```rb 5.times { |i| print i*2 }```


### Google
Returns the first result via Google Search.

Usage: ```go(ogle) [query]```

Examples: ```go cinema in Prague``` or ```google iPad8 review```


### Help
Prints information about a command (or all commands with no name specified).

Usage: ```help [name]```

Example: ```help``` or ```help calculator```


### Title
Prints the title of a page specified in parameter.

Usage: ```t [url]```

Example: ```t http://www.seznam.cz/```


### Translator
Translates the query string. Lang parameters are optional for the first pattern.

Usage: ```[source-lang] [to-lang] "[query]"?``` or ```[source-lang] to [to-lang] [query]```

Example: ```en cs "dog"?``` or ```"dog"?``` or ```en to cz dog```


### Twitter
Prints the user status. Plugin also works automatically for detected Twitter URLs.

Usage: ```tw [status]```

Example: ```tw 297374318562779137```


### Wiki
Returns the first result via MediaWiki.

Usage: ```wik(i)(-[lang]) [query]```

Example: ```wik-en hamster```


### YouTube
YouTube plugin automatically prints video titles from detected URLs.
