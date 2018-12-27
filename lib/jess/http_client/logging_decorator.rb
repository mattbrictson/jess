require "delegate"

module Jess
  class HttpClient
    # Wraps a Net::HTTP object to log all requests to a given Logger object.
    class LoggingDecorator < SimpleDelegator
      def initialize(logger, http)
        super(http)
        @logger = logger
      end

      def request(req)
        return super if logger.nil?

        log_request(req)
        response = super
        log_response(response, req.uri)
        response
      rescue Error => e
        logger&.error(e.to_s)
        raise
      end

      private

      attr_reader :logger

      def log_request(req)
        logger.debug { "#{req.method} #{req.uri}" }
      end

      def log_response(response, uri)
        logger.debug do
          "Received #{response_desc(response)} from #{uri}"
        end
      end

      def response_desc(response)
        content_type = response.content_type
        desc = ""
        desc << if response.body && response.body.length
                  "#{response.body.length} bytes"
                else
                  "response"
                end
        desc << " (#{content_type})" if content_type
        desc
      end
    end
  end
end
