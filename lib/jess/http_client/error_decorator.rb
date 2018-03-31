require "delegate"

module Jess
  class HttpClient
    # Wraps a Net::HTTP object to provide exception handling around the
    # `request` method, such that 400 and 500 error codes are translated into
    # appropriate Jess::HttpClient::Error exceptions.
    #
    class ErrorDecorator < SimpleDelegator
      def request(req)
        super.tap do |response|
          raise_if_error_code(response)
        end
      rescue StandardError => e
        handle_exception(e, req)
      end

      private

      def raise_if_error_code(res)
        return if res.is_a?(Net::HTTPSuccess)
        raise BadCredentials, res.message if res.code == "401"
        raise NotFound, res.message if res.code == "404"
        raise ServerError, res.message if res.is_a?(Net::HTTPServerError)
        raise Error, res.message
      end

      # rubocop:disable Lint/EmptyWhen
      def handle_exception(err, req)
        case err
        when IOError, Timeout::Error
          err = ConnectionError.new(err.message)
        when Error
          # pass
        else
          err = Error.new(err.inspect)
        end

        err.uri = req.uri
        err.http_method = req.method
        raise err
      end
      # rubocop:enable Lint/EmptyWhen
    end
  end
end
