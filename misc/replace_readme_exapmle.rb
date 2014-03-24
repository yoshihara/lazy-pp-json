#!/usr/bin/env ruby

require "lazy-pp-json"

example_json = <<JSON
[[0,1395671860.99505,2.50339508056641e-05],{"alloc_count":136,"starttime":1395671856,"uptime":4,"version":"4.0.0","n_queries":0,"cache_hit_rate":0.0,"command_version":1,"default_command_version":1,"max_command_version":2}]
JSON

normal_pretty_json = JSON.pretty_generate(JSON.parse(example_json))
normal_pp = normal_pretty_json.each_line.map{|line| "# #{line}"}.join
normal_pp_exapmle = <<EXAMPLE

```ruby
example_json = "#{example_json.chomp}"
puts JSON.pretty_generate(JSON.parse(example_json))
#=>
#{normal_pp}
```

EXAMPLE

pretty_json = Lazy::PP::JSON.new(example_json)
lazy_pp = pretty_json.pretty_inspect.each_line.map{|line| "# #{line}"}.join
lazy_pp_example = <<EXAMPLE

```ruby
example_json = "#{example_json.chomp}"
pp Lazy::PP::JSON.new(example_json)
#=>
#{lazy_pp}
```

EXAMPLE

readme_dir = File.join(File.dirname(__FILE__), "..")
readme_path = File.join(readme_dir, "README.md")
readme = File.read(readme_path)

readme = readme.gsub(/###( JSON#pretty_generate)\n.+###/m, "###\\1\n#{normal_pp_exapmle}###")
readme = readme.gsub(/###( lazy-pp-json)\n.+?##/m, "###\\1\n#{lazy_pp_example}##")

File.open(readme_path, "w") do |file|
  file.puts readme
end
