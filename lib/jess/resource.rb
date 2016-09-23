module Jess
  # Wraps a JSON object that is returned from the JSS API. The underlying raw
  # JSON is available via `_json`. Properties of the JSON can be accessed via
  # `method_missing`, so that a Resource behaves like a typical Ruby object.
  # Accessing a non-existent JSON property will raise `NoMethodError`.
  #
  class Resource
    attr_reader :_json

    def initialize(json)
      @_json = json.freeze
    end

    private

    def method_missing(symbol, *args)
      if _json.key?(symbol.to_s)
        _as_resource(_json.public_send(:[], symbol.to_s, *args))
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_all)
      super || _json.key?(symbol.to_s)
    end

    def _as_resource(json)
      case json
      when Hash
        Resource.new(json)
      when Array
        json.map(&method(:_as_resource))
      else
        json
      end
    end
  end
end
