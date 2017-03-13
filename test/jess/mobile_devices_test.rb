require "test_helper"

class Jess::MobileDevicesTest < Minitest::Test
  include JSONFixtures

  def test_find
    response = json_fixture("mobile_device_656", raw: true)
    http = Minitest::Mock.new
    http.expect(:get, response, ["mobiledevices/id/656"])

    devices = Jess::MobileDevices.new(http)
    dev = devices.find(656)
    assert_instance_of(Jess::MobileDevice, dev)
    assert_equal(656, dev.id)

    http.verify
  end

  def test_all_ids
    response = json_fixture("mobile_devices", raw: true)
    http = Minitest::Mock.new
    http.expect(:get, response, ["mobiledevices"])

    devices = Jess::MobileDevices.new(http)
    ids = devices.all_ids
    assert_equal([650, 576, 591], ids)

    http.verify
  end
end
