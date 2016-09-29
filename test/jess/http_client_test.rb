require "test_helper"

class Jess::HttpClientTest < Minitest::Test
  include JSONFixtures

  class FakeLogger
    attr_reader :messages

    def initialize
      @messages = []
    end

    def debug
      messages << "D: #{yield}"
    end

    def error(msg)
      messages << "E: #{msg}"
    end
  end

  def test_get_returns_body
    client = new_client
    stub_http_get("https://host/JSSResource/test").to_return(body: "value")
    result = client.get("test")
    assert_equal("value", result)
  end

  def test_honors_non_root_jss_path
    client = new_client("https://host/path/to/jss")
    stub_http_get("https://host/path/to/jss/JSSResource/test")
    client.get("test")
  end

  def test_logs_successful_request
    logger = FakeLogger.new
    client = new_client(logger: logger)
    stub_http_get("https://host/JSSResource/test").to_return(
      body: '{ "sample": "value" }',
      headers: { "Content-Type" => "application/json" }
    )
    client.get("test")

    assert_equal(
      [
        "D: GET https://host/JSSResource/test",
        "D: Received 21 bytes (application/json) "\
          "from https://host/JSSResource/test"
      ],
      logger.messages
    )
  end

  def test_logs_error
    logger = FakeLogger.new
    client = new_client(logger: logger)
    stub_http_get("https://host/JSSResource/test")
      .to_return(status: [404, "Not found"])

    begin
      client.get("test")
    rescue
      nil
    end

    assert_equal(
      [
        "D: GET https://host/JSSResource/test",
        "E: Not found (during GET https://host/JSSResource/test)"
      ],
      logger.messages
    )
  end

  def test_raises_not_found_when_404
    client = new_client
    stub_http_get("https://host/JSSResource/test").to_return(status: 404)

    assert_raises(Jess::HttpClient::NotFound) do
      client.get("test")
    end
  end

  def test_raises_bad_credentials_when_401
    client = new_client
    stub_http_get("https://host/JSSResource/test").to_return(status: 401)

    assert_raises(Jess::HttpClient::BadCredentials) do
      client.get("test")
    end
  end

  def test_raises_error_when_406
    client = new_client
    stub_http_get("https://host/JSSResource/test").to_return(status: 406)

    assert_raises(Jess::HttpClient::Error) do
      client.get("test")
    end
  end

  def test_raises_server_error_when_500
    client = new_client
    stub_http_get("https://host/JSSResource/test").to_return(status: 500)

    assert_raises(Jess::HttpClient::ServerError) do
      client.get("test")
    end
  end

  private

  def new_client(url="https://host", logger: nil)
    Jess::HttpClient.new(
      url,
      username: "demo_user",
      password: "demo_password",
      logger: logger
    )
  end

  def stub_http_get(url)
    stub_request(:get, url).with(
      basic_auth: %w(demo_user demo_password),
      headers: {
        "Accept" => "application/json",
        "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
        "Host" => URI(url).host,
        "User-Agent" => "Ruby"
      }
    )
  end
end
