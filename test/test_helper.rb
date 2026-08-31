require "jess"

module Jess
  class Test < Megatest::Test
  end
end

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |rb| require(rb) }
