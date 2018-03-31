require "json"

module JSONFixtures
  def json_fixture(name, raw: false)
    fix_dir = File.expand_path("../fixtures", __dir__)
    json = IO.read(File.join(fix_dir, "#{name}.json"))
    raw ? json : JSON.parse(json)
  end
end
