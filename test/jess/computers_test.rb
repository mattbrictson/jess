require "test_helper"

class Jess::ComputersTest < Minitest::Test
  include JSONFixtures

  def test_find
    response = json_fixture("computer_4123", raw: true)
    http = Minitest::Mock.new
    http.expect(:get, response, ["computers/id/4123"])

    computers = Jess::Computers.new(http)
    cpu = computers.find(4123)
    assert_instance_of(Jess::Computer, cpu)
    assert_equal(4123, cpu.id)

    http.verify
  end
end
