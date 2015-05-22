# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'store2/version'

Gem::Specification.new do |spec|
  spec.name          = "store2"
  spec.version       = Store2::VERSION
  spec.authors       = ["Oleksii Fedorov"]
  spec.email         = ["waterlink000@gmail.com"]
  spec.summary       = %q{Persistence in YAML files, yay!}
  spec.description   = %q{Persistence in YAML files, yay!}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
