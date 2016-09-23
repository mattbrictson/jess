require "test_helper"

class Jess::ConnectionTest < Minitest::Test
  def setup
    @http = Object.new
    @conn = Jess::Connection.new(@http)
  end

  def test_computers
    computers = @conn.computers
    assert_instance_of(Jess::Computers, computers)
    assert_same(computers, @conn.computers)
    assert_same(@http, computers.http_client)
  end

  def test_mobile_devices
    devs = @conn.mobile_devices
    assert_instance_of(Jess::MobileDevices, devs)
    assert_same(devs, @conn.mobile_devices)
    assert_same(@http, devs.http_client)
  end
end
