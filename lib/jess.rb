require "jess/version"

# Jess is a lightweight client for the JAMF Software Server (JSS) API.
#
# Example usage:
#
# conn = Jess.connect("https://jsshost", username: "user", password: "secret")
# computer = conn.computers.find(1234)
# computer.id             # => 1234
# computer.name           # => "Matt's iMac"
# computer.hardware.model # => "iMac Intel (Retina 5k, 27-Inch, Late 2015)"
#
module Jess
  autoload :Computer, "jess/computer"
  autoload :Computers, "jess/computers"
  autoload :Connection, "jess/connection"
  autoload :ExtensionAttributes, "jess/extension_attributes"
  autoload :HttpClient, "jess/http_client"
  autoload :MobileDevice, "jess/mobile_device"
  autoload :MobileDevices, "jess/mobile_devices"
  autoload :Resource, "jess/resource"

  # Establish a connection with JSS and return a Jess::Connection object that
  # can be used to interact with the JSS API. This is a convenience method. For
  # more fine-grained control over the connection, create a Jess::HttpClient
  # using the desired options, then pass it to Jess::Connection.new.
  #
  def self.connect(url, username:, password:)
    client = HttpClient.new(url, username:, password:)
    Connection.new(client)
  end
end
