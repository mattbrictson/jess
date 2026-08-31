require "webmock"

WebMock.enable!
WebMock::AssertionFailure.error_class = Megatest::Assertion

module Jess
  class Test
    include WebMock::API

    teardown do
      WebMock.reset!
    end
  end
end
