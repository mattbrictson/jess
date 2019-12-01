lib = File.expand_path("lib", __dir__)
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

  spec.metadata      = {
    "homepage_uri" => "https://github.com/mattbrictson/jess",
    "changelog_uri" => "https://github.com/mattbrictson/jess/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/mattbrictson/jess/",
    "bug_tracker_uri" => "https://github.com/mattbrictson/jess/issues"
  }

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.4.0"

  spec.add_development_dependency "awesome_print", "~> 1.7"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "coveralls", "~> 0.8.15"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~>1.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "= 0.76.0"
  spec.add_development_dependency "rubocop-performance", "= 1.5.1"
  spec.add_development_dependency "webmock", "~> 3.1"
end
