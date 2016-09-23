require "json"

module Jess
  # Mobile device-related JSS API operations
  class MobileDevices
    attr_reader :http_client

    def initialize(http_client)
      @http_client = http_client
    end

    # Retrieve a mobile device by ID.
    def find(id)
      json = JSON.parse(http_client.get("mobiledevices/id/#{id}"))
      MobileDevice.new(json.fetch("mobile_device"))
    end
  end
end
