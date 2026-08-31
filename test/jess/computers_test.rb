class Jess::ComputersTest < Jess::Test
  include JSONFixtures

  def test_find
    response = json_fixture("computer_4123", raw: true)
    http = new_client
    stub_request(:get, "https://host/JSSResource/computers/id/4123").to_return(body: response)

    computers = Jess::Computers.new(http)
    cpu = computers.find(4123)
    assert_instance_of(Jess::Computer, cpu)
    assert_equal(4123, cpu.id)
  end

  def test_all_ids
    response = json_fixture("computers", raw: true)
    http = new_client
    stub_request(:get, "https://host/JSSResource/computers").to_return(body: response)

    computers = Jess::Computers.new(http)
    ids = computers.all_ids
    assert_equal([2486, 4155, 1235], ids)
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
