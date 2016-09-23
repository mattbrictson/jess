require "test_helper"

class JessTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil(::Jess::VERSION)
  end

  def test_connect_builds_connection_with_given_params
    url = "http://test"
    username = "hello"
    password = "hush"

    conn = Jess.connect(url, username: username, password: password)

    assert_instance_of(Jess::Connection, conn)

    client = conn.http_client
    assert_equal(url, client.url)
    assert_equal(username, client.username)
    assert_equal(password, client.instance_variable_get(:@password))
  end
end
