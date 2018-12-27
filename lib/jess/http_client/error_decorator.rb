require "delegate"

module Jess
  class HttpClient
    # Wraps a Net::HTTP object to provide exception handling around the
    # `request` method, such that 400 and 500 error codes are translated into
    # appropriate Jess::HttpClient::Error exceptions.
    #
    class ErrorDecorator < SimpleDelegator
      def request(req)
        res = super
        raise_if_error_code(res)
        res
      rescue StandardError => e
        handle_exception(e, req, res)
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
      def handle_exception(err, req, res)
        case err
        when IOError, Timeout::Error
          err = ConnectionError.new(err.message)
        when Error
          # pass
        else
          err = Error.new(err.inspect)
        end

        fill_exception(err, req, res)
        raise err
      end
      # rubocop:enable Lint/EmptyWhen

      def fill_exception(err, req, res)
        err.uri = req.uri
        err.http_method = req.method
        return if res.nil?

        err.code = res.code

        begin
          err.response = res.body.to_s
        rescue StandardError
          err.response = nil
        end
      end
    end
  end
end
