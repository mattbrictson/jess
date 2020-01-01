$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "jess"

# Load everything else from test/support
Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |rb| require(rb) }

require "webmock/minitest"
require "minitest/autorun"
