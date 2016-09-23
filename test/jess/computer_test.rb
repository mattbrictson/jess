require "test_helper"

class Jess::ComputerTest < Minitest::Test
  include JSONFixtures

  def setup
    @computer = Jess::Computer.new(json_fixture("computer_4123")["computer"])
  end

  def test_id
    assert_equal(4123, @computer.id)
  end

  def test_name
    assert_equal("Demo Computer", @computer.name)
  end

  def test_general_attributes
    gen = @computer.general
    refute_nil(gen)
    assert_equal("Demo Computer", gen.name)
    assert_equal("E16GL410DN42", gen.serial_number)
    assert_equal("12:34:56:3F:94:1D", gen.mac_address)
    assert_equal("AA:23:C8:30:2B:70", gen.alt_mac_address)
    assert_equal("10.0.0.9", gen.ip_address)
    assert_equal("2016-09-25T21:07:40.946-0500", gen.report_date_utc)
    assert_equal("2016-09-26T13:07:35.386-0500", gen.last_contact_time_utc)
  end

  def test_location_attributes
    loc = @computer.location
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

  def test_hardware_attributes
    hdw = @computer.hardware
    refute_nil(hdw)
    assert_equal("Apple", hdw.make)
    assert_equal("15-inch Retina MacBook Pro (Late 2013)", hdw.model)
    assert_equal("MacBookPro11,3", hdw.model_identifier)
    assert_equal("Mac OS X", hdw.os_name)
    assert_equal("10.9.5", hdw.os_version)
    assert_equal("13F1712", hdw.os_build)
    assert_equal("Intel Core i7", hdw.processor_type)
    assert_equal("x86_64", hdw.processor_architecture)
    assert_equal(2300, hdw.processor_speed)
    assert_equal(1, hdw.number_processors)
    assert_equal(4, hdw.number_cores)
    assert_equal(16_384, hdw.total_ram_mb)
    assert_equal(98, hdw.battery_capacity)
    assert_equal(0, hdw.available_ram_slots)
  end

  def test_storage_is_array
    stor = @computer.hardware.storage
    refute_nil(stor)
    assert_instance_of(Array, stor)
    assert_equal(2, stor.size)
  end

  def test_device_attributes
    dev = @computer.hardware.storage.first
    refute_nil(dev)
    assert_equal("disk0", dev.disk)
    assert_equal("APPLE SSD SM0512F", dev.model)
    assert_equal(512_287, dev.drive_capacity_mb)
    assert_equal("Verified", dev.smart_status)
  end

  def test_partition_attributes
    part = @computer.hardware.storage.first.partition
    refute_nil(part)
    assert_equal("Macintosh HD (Boot Partition)", part.name)
    assert_equal("boot", part.type)
    assert_equal(476_282, part.partition_capacity_mb)
    assert_equal(98, part.percentage_full)
    assert_equal("Not Encrypted", part.filevault_status)
    assert_equal("Not Encrypted", part.filevault2_status)
  end

  def test_purchasing_attributes
    pur = @computer.purchasing
    refute_nil(pur)
    assert_equal("2014-05-10T00:00:00.000-0500", pur.po_date_utc)
    assert_equal("2017-05-10T00:00:00.000-0500", pur.warranty_expires_utc)
  end

  def test_extension_attributes
    attrs = @computer.extension_attributes
    assert_equal("demo@example.com", attrs["[1] Contact Address"])
  end
end
