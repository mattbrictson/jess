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
        log_response(response)
        response
      rescue Error => e
        logger.error(e.to_s)
        raise
      end

      private

      attr_reader :logger

      def log_request(req)
        logger.debug { "#{req.method} #{req.uri}" }
      end

      def log_response(response)
        logger.debug do
          content_type = response.content_type
          msg = "Received #{response.body.length} bytes "
          msg << "(#{content_type}) " if content_type
          msg << "from #{response.uri}"
        end
      end
    end
  end
end
