require "webmock"

WebMock.enable!

class JessTest
  include WebMock::API

  teardown do
    WebMock.reset!
  end

  def assert_request_requested(...)
    @__m.assert { super }
  end

  def assert_request_not_requested(...)
    @__m.assert { super }
  end
end

WebMock::AssertionFailure.error_class = Megatest::Assertion
