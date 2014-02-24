# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lazy/pp/json/version'

Gem::Specification.new do |spec|
  spec.name          = "lazy-pp-json"
  spec.version       = Lazy::PP::Json::VERSION
  spec.authors       = ["yoshihara"]
  spec.email         = ["h.yoshihara@everyleaf.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "test-unit-notify"
  spec.add_development_dependency "rake"
end
