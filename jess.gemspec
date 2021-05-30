require_relative "lib/jess/version"

Gem::Specification.new do |spec|
  spec.name = "jess"
  spec.version = Jess::VERSION
  spec.authors = ["Matt Brictson"]
  spec.email = ["opensource@mattbrictson.com"]

  spec.summary = "Lightweight, unofficial client for the JAMF Software Server (JSS) API"
  spec.homepage = "https://github.com/mattbrictson/jess"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "changelog_uri" => "https://github.com/mattbrictson/jess/releases",
    "source_code_uri" => "https://github.com/mattbrictson/jess/",
    "bug_tracker_uri" => "https://github.com/mattbrictson/jess/issues"
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
