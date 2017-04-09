# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jess/version"

Gem::Specification.new do |spec|
  spec.name          = "jess"
  spec.version       = Jess::VERSION
  spec.authors       = ["Matt Brictson"]
  spec.email         = ["opensource@mattbrictson.com"]

  spec.summary       = "Lightweight, unofficial client for the JAMF Software "\
                       "Server (JSS) API"
  spec.homepage      = "https://github.com/mattbrictson/jess"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.1.0"

  spec.add_development_dependency "awesome_print", "~> 1.7"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "chandler", "~> 0.3"
  spec.add_development_dependency "coveralls", "~> 0.8.15"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~>1.1"
  spec.add_development_dependency "rainbow", "~> 2.2"
  spec.add_development_dependency "rubocop", "0.48.1"
  spec.add_development_dependency "webmock", "~> 2.1"
end
