# coding: utf-8
base_dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.expand_path("lib", base_dir))

require 'lazy/pp/json/version'

readme_path = File.join(base_dir, "README.md")
entries = File.read(readme_path).split(/^##\s(.*)$/)
entry = lambda do |entry_title|
  entries[entries.index(entry_title) + 1]
end
clean_white_space = lambda do |entry|
  entry.gsub(/(\A\n+|\n+\z)/, '')
end

description = clean_white_space.call(entry.call("Description"))
summary = description.gsub(/\.\n.+\Z/m ,"") + "\n"

Gem::Specification.new do |spec|
  spec.name          = "lazy-pp-json"
  spec.version       = Lazy::PP::JSON::VERSION
  spec.authors       = ["yoshihara"]
  spec.email         = ["h.yoshihara@everyleaf.com"]
  spec.description   = description
  spec.summary       = summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files = ["README.md", "LICENSE.txt"]
  spec.files += ["Rakefile", "Gemfile", "lazy-pp-json.gemspec"]
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("doc/text/*.*")
  spec.test_files = Dir.glob("test/**/*.rb")
  Dir.chdir("bin") do
    spec.executables = Dir.glob("*")
  end
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "test-unit-notify"
  spec.add_development_dependency "rake"
end
