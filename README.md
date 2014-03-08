# lazy-pp-json

## Description

Lazy pp json responses.

### Normal pp

```ruby
pp JSON.parse('{"key1":{"key1-1":"value1-1","key1-2":"value1-2"}, "key2":"value2"}')
#=> {"key1"=>{"key1-1"=>"value1-1", "key1-2"=>"value1-2"}, "key2"=>"value2"}
```

### lazy-pp-json

```ruby
pp Lazy::PP::JSON.new('{"key1":{"key1-1":"value1-1","key1-2":"value1-2"}, "key2":"value2"}')
#=>
# {
#   "key1":
#   {
#     "key1-1":"value1-1",
#     "key1-2":"value1-2"
#   },
#   "key2":"value2"
# }
#
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
