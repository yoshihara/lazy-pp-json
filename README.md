# lazy-pp-json

[![Build Status](https://travis-ci.org/yoshihara/lazy-pp-json.png?branch=master)](https://travis-ci.org/yoshihara/lazy-pp-json)

## Description

Lazy pp json responses.

### JSON#pretty_generate

```
[
  [
    0,
    1395671860.99505,
    2.50339508056641e-05
  ],
  {
    "alloc_count": 136,
    "starttime": 1395671856,
    "uptime": 4,
    "version": "4.0.0",
    "n_queries": 0,
    "cache_hit_rate": 0.0,
    "command_version": 1,
    "default_command_version": 1,
    "max_command_version": 2
  }
]
```

### lazy-pp-json

```
[
  [
    0,
    1395671803.76874,
    4.10079956054688e-05
  ],
  {
    "alloc_count"            :175,
    "starttime"              :1395671727,
    "uptime"                 :76,
    "version"                :"4.0.0",
    "n_queries"              :1,
    "cache_hit_rate"         :0.0,
    "command_version"        :1,
    "default_command_version":1,
    "max_command_version"    :2
  }
]
```

## Installation

    $ gem install lazy-pp-json

## Usage

```ruby
require "lazy-pp-json"

pp Lazy::PP::JSON.new(json_string)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
