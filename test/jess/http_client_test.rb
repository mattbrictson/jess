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

  def test_logs_empty_request
    logger = FakeLogger.new
    client = new_client(logger: logger)
    stub_http_get("https://host/JSSResource/test")
    client.get("test")

    assert_equal(
      [
        "D: GET https://host/JSSResource/test",
        "D: Received response from https://host/JSSResource/test"
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

  def test_raises_connection_error_when_timeout
    client = new_client
    stub_http_get("https://host/JSSResource/test").to_timeout

    assert_raises(Jess::HttpClient::ConnectionError) do
      client.get("test")
    end
  end

  def test_raises_connection_error_when_io_error
    client = new_client
    stub_http_get("https://host/JSSResource/test").to_raise(IOError)

    assert_raises(Jess::HttpClient::ConnectionError) do
      client.get("test")
    end
  end

  def test_raises_error_when_other_error
    client = new_client
    stub_http_get("https://host/JSSResource/test").to_raise(StandardError)

    assert_raises(Jess::HttpClient::Error) do
      client.get("test")
    end
  end

  def test_applies_net_http_options
    client = Jess::HttpClient.new(
      "https://host",
      username: "user",
      password: "secret",
      net_http_options: {
        keep_alive_timeout: 7,
        open_timeout: 13,
        read_timeout: 19,
        verify_mode: OpenSSL::SSL::VERIFY_NONE
      }
    )
    http = client.send(:http)

    assert_equal(7, http.keep_alive_timeout)
    assert_equal(13, http.open_timeout)
    assert_equal(19, http.read_timeout)
    assert_equal(OpenSSL::SSL::VERIFY_NONE, http.verify_mode)
  end

  def test_inspect_shows_username_and_url
    client = new_client
    assert_equal(
      "Jess::HttpClient<https://demo_user@host/JSSResource/>",
      client.inspect
    )
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
      basic_auth: %w[demo_user demo_password],
      headers: {
        "Accept" => "application/json",
        "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
        "Host" => URI(url).host,
        "User-Agent" => "Ruby"
      }
    )
  end
end
