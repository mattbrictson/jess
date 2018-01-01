require "test_helper"

class Jess::ExtensionAttributesTest < Minitest::Test
  include JSONFixtures

  def setup
    @computer = Jess::Computer.new(json_fixture("computer_4123")["computer"])
    @attrs = @computer.extension_attributes
  end

  def test_size
    assert_equal(7, @attrs.size)
  end

  def test_key_question
    assert(@attrs.key?("Battery Cycle Count"))
    refute(@attrs.key?("Unknown Attribute"))
  end

  def test_keys
    assert_equal(
      [
        "[1] Contact Address",
        "[A] Hardware - Current Uptime",
        "[A] Hardware - Kernel Panics",
        "[A] Memory - General Errors",
        "[A] Power-On Self Test Errors",
        "Battery Cycle Count",
        "Battery Health Status"
      ],
      @attrs.keys
    )
  end

  def test_fetch
    assert_equal("demo@example.com", @attrs.fetch("[1] Contact Address"))
    assert_raises(KeyError) { @attrs.fetch("Unknown Attribute") }
  end

  def test_hash_access
    assert_equal("demo@example.com", @attrs["[1] Contact Address"])
    assert_equal("13 days", @attrs["[A] Hardware - Current Uptime"])
    assert_equal("0", @attrs["[A] Hardware - Kernel Panics"])
    assert_equal("OK", @attrs["[A] Memory - General Errors"])
    assert_equal("Passed", @attrs["[A] Power-On Self Test Errors"])
    assert_equal("74", @attrs["Battery Cycle Count"])
    assert_equal("OK", @attrs["Battery Health Status"])
    assert_nil(@attrs["Unknown Attribute"])
  end

  def test_to_h
    assert_instance_of(Hash, @attrs.to_h)
    assert_equal(@attrs.keys, @attrs.to_h.keys)
  end

  def test_raw_json_access
    assert_equal(@computer._json["extension_attributes"], @attrs._json)
  end
end
