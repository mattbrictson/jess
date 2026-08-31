class Jess::MobileDevicesTest < Jess::Test
  include JSONFixtures

  def test_find
    response = json_fixture("mobile_device_656", raw: true)
    http = new_client
    stub_request(:get, "https://host/JSSResource/mobiledevices/id/656").to_return(body: response)

    devices = Jess::MobileDevices.new(http)
    dev = devices.find(656)
    assert_instance_of(Jess::MobileDevice, dev)
    assert_equal(656, dev.id)
  end

  def test_all_ids
    response = json_fixture("mobile_devices", raw: true)
    http = new_client
    stub_request(:get, "https://host/JSSResource/mobiledevices").to_return(body: response)

    devices = Jess::MobileDevices.new(http)
    ids = devices.all_ids
    assert_equal([650, 576, 591], ids)
  end

  private

  def new_client(url="https://host")
    Jess::HttpClient.new(
      url,
      username: "demo_user",
      password: "demo_password",
      logger: nil
    )
  end
end
