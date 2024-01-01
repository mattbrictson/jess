require "logger"
require "net/http"

module Jess
  # Provides low-level access to making authenticated GET requests to the JSS
  # API, with basic logging and error handling. You will normally not need to
  # use this class directly, unless you need to make HTTP requests that haven't
  # been wrapped by the higher level `Jess::Connection` API.
  #
  class HttpClient
    autoload :Error,            "jess/http_client/error"
    autoload :BadCredentials,   "jess/http_client/error"
    autoload :ConnectionError,  "jess/http_client/error"
    autoload :LoggingDecorator, "jess/http_client/logging_decorator"
    autoload :NotFound,         "jess/http_client/error"
    autoload :ServerError,      "jess/http_client/error"
    autoload :ErrorDecorator,   "jess/http_client/error_decorator"

    attr_reader :url, :username, :logger, :net_http_options

    def initialize(url, username:, password:,
                   logger: default_logger, net_http_options: nil)
      @url = url
      @username = username
      @password = password
      @net_http_options = net_http_options || {}
      @logger = logger
    end

    # Makes a GET request for the given path. The result is the raw, unparsed
    # body of the HTTP response. The path is resolved relative to the
    # `resource_uri` and should not start with a slash.
    def get(path, accept: "application/json")
      req = Net::HTTP::Get.new(URI.join(resource_uri, path))
      req.basic_auth(username, password)
      req["Accept"] = accept
      response = http.request(req)
      response.body.to_s
    end

    # The canonical JSSResource URI used to issue requests.
    def resource_uri
      @resource_uri ||= begin
        root_url = url.to_s.sub(%r{JSSResource/*$}, "")
        root_url << "/" unless root_url.end_with?("/")
        URI.join(root_url, "JSSResource/")
      end
    end

    def inspect
      url = resource_uri.to_s.sub(%r{://}, "://#{username}@")
      "Jess::HttpClient<#{url}>"
    end

    private

    attr_reader :password

    def default_logger
      defined?(Rails) ? Rails.logger : Logger.new($stderr)
    end

    def http
      @http ||= begin
        http = Net::HTTP.new(resource_uri.host, resource_uri.port)
        http.read_timeout = 15
        http.open_timeout = 15
        http.use_ssl = true if resource_uri.scheme == "https"
        apply_net_http_options(http)
        LoggingDecorator.new(logger, ErrorDecorator.new(http))
      end
    end

    def apply_net_http_options(http)
      net_http_options.each do |attr, value|
        http.public_send(:"#{attr}=", value)
      end
    end
  end
end
