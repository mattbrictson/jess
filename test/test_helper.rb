require "jess"

class JessTest < Megatest::Test
end

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |rb| require(rb) }
