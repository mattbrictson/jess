require "test_helper"

class Jess::MobileDeviceTest < Minitest::Test
  include JSONFixtures

  def setup
    @dev = Jess::MobileDevice.new(
      json_fixture("mobile_device_656")["mobile_device"]
    )
  end

  def test_id
    assert_equal(656, @dev.id)
  end

  def test_name
    assert_equal("Demo iPhone 6", @dev.name)
  end

  def test_general_attributes
    gen = @dev.general
    refute_nil(gen)
    assert_equal("Demo iPhone 6", gen.name)
    assert_equal("G19XF522L161", gen.serial_number)
    assert_equal("8e4b386215c7fdcfec1e4ab3212f392df471351e", gen.udid)
    assert_equal("1C:0E:18:29:10:78", gen.wifi_mac_address)
    assert_equal("41:49:D6:AA:A4:88", gen.bluetooth_mac_address)
    assert_equal("10.0.0.5", gen.ip_address)
    assert_equal("2015-10-06T11:14:19.055-0500", gen.initial_entry_date_utc)
    assert_equal("2015-10-06T11:14:29.975-0500", gen.last_enrollment_utc)
    assert_equal("iPhone 6", gen.model_display)
    assert_equal(116_166, gen.capacity_mb)
    assert_equal(76_468, gen.available_mb)
  end

  def test_location_attributes
    loc = @dev.location
    refute_nil(loc)
    assert_equal("matt", loc.username)
    assert_equal("Matt", loc.real_name)
    assert_equal("hello@example.com", loc.email_address)
    assert_equal("Manager", loc.position)
    assert_equal("555-1234", loc.phone)
    assert_equal("Demo Department", loc.department)
    assert_equal("Demo Building", loc.building)
    assert_equal("Demo Room", loc.room)
  end

  def test_purchasing_attributes
    pur = @dev.purchasing
    refute_nil(pur)
    assert_equal("2014-09-19T00:00:00.000-0500", pur.po_date_utc)
    assert_equal("", pur.warranty_expires_utc)
  end

  def test_security_attributes
    sec = @dev.security
    refute_nil(sec)
    assert(sec.data_protection)
    assert(sec.block_level_encryption_capable)
    assert(sec.file_level_encryption_capable)
    assert(sec.passcode_present)
    assert(sec.passcode_compliant)
    assert(sec.passcode_compliant_with_profile)
    assert_equal(3, sec.hardware_encryption)
    assert(sec.activation_lock_enabled)
    assert_equal("Unknown", sec.jailbreak_detected)
  end

  def test_configuration_profiles
    prof = @dev.configuration_profiles
    refute_nil(prof)
    assert_instance_of(Array, prof)
    assert_equal(2, prof.size)
    assert_equal("CA Certificate", prof.first.display_name)
  end

  def test_mobile_device_groups
    groups = @dev.mobile_device_groups
    refute_nil(groups)
    assert_instance_of(Array, groups)
    assert_equal(1, groups.size)
    assert_equal("All Managed iPhones", groups.first.name)
  end

  def test_extension_attributes
    attrs = @dev.extension_attributes
    assert_equal("", attrs["Secondary Status"])
  end

  def test_inspect_shows_only_id_and_name
    assert_equal("Jess::MobileDevice<#656, Demo iPhone 6>", @dev.inspect)
  end
end
