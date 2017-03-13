require "json"

module Jess
  # Computer-related JSS API operations
  class Computers
    attr_reader :http_client

    def initialize(http_client)
      @http_client = http_client
    end

    # Retrieve a computer by ID.
    def find(id)
      json = JSON.parse(http_client.get("computers/id/#{id}"))
      Computer.new(json.fetch("computer"))
    end

    # Get all computer IDs.
    def all_ids
      json = JSON.parse(http_client.get("computers"))
      json["computers"].map { |c| c["id"] }
    end
  end
end
