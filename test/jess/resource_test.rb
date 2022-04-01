require "test_helper"

class Jess::ResourceTest < Minitest::Test
  def setup
    @json = JSON.parse(<<-STR)
      {
        "first_name": "Matt",
        "rank": 5,
        "bio": null,
        "notification": {
          "enabled": true,
          "email": "matt@example.com"
        },
        "aliases": [
          "Matthew",
          "M"
        ]
      }
    STR
    @rsrc = Jess::Resource.new(@json)
  end

  def test_original_json_can_be_accessed_but_is_frozen
    assert_equal(@json, @rsrc._json)
    assert_equal(@json, @rsrc.to_hash)
    assert_predicate(@rsrc._json, :frozen?)
  end

  def test_null
    assert_nil(@rsrc.bio)
  end

  def test_integer_value
    assert_equal(5, @rsrc.rank)
  end

  def test_array_of_strings
    assert_equal(%w[Matthew M], @rsrc.aliases)
  end

  def test_nested_resource
    nested = @rsrc.notification
    assert_instance_of(Jess::Resource, nested)
    assert(nested.enabled)
    assert_equal("matt@example.com", nested.email)
  end

  def test_unknown_attribute_raises_no_method_error
    assert_raises(NoMethodError) { @rsrc.unknown_attr }
  end

  def test_respond_to_reflects_json_attribute_names
    assert_respond_to(@rsrc, :first_name)
    assert_respond_to(@rsrc, :rank)
    assert_respond_to(@rsrc, :bio)
    assert_respond_to(@rsrc, :notification)
    assert_respond_to(@rsrc, :aliases)

    refute_respond_to(@rsrc, :firstname)
    refute_respond_to(@rsrc, :unknown_attr)
  end
end
