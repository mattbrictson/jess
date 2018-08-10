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
    ConnectionError = Class.new(Error)

    # Raised when Jess::HttpClient receives a 500 error from the server.
    ServerError = Class.new(Error)

    # Raised when Jess::HttpClient receives a 404 error from the server.
    NotFound = Class.new(Error)

    # Raised when Jess::HttpClient receives a 401 error from the server, which
    # happens when the username and/or password are incorrect.
    BadCredentials = Class.new(Error)
  end
end
