module Jess
  class HttpClient
    # Base class for exceptions raised by Jess::HttpClient. These exceptions
    # hold a reference to the URI and HTTP method (e.g. "GET", "POST") that were
    # being attempted when the error occurred.
    #
    class Error < StandardError
      attr_accessor :uri, :http_method, :code, :response

      def to_s
        message = [code, super].join(" ").strip
        "#{message} (during #{http_method.to_s.upcase} #{uri})"
      end
    end

    # Raised when Jess::HttpClient fails to open an HTTP connection.
    class ConnectionError < Error
    end

    # Raised when Jess::HttpClient receives a 500 error from the server.
    class ServerError < Error
    end

    # Raised when Jess::HttpClient receives a 404 error from the server.
    class NotFound < Error
    end

    # Raised when Jess::HttpClient receives a 401 error from the server, which
    # happens when the username and/or password are incorrect.
    class BadCredentials < Error
    end
  end
end
