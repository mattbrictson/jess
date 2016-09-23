module Jess
  # Provides a high-level facade for operations of the JSS API. This is the
  # primary interface for all operations provided by the Jess gem.
  class Connection
    attr_reader :http_client

    def initialize(http_client)
      @http_client = http_client
    end

    def computers
      @computers ||= Computers.new(http_client)
    end

    def mobile_devices
      @mobile_devices ||= MobileDevices.new(http_client)
    end

    def inspect
      "Jess::Connection<#{http_client.inspect}>"
    end
  end
end
