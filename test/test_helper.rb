$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "jess"

require "minitest/autorun"
require "webmock/minitest"
Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |rb| require(rb) }
