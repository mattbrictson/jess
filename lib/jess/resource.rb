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

    def to_hash
      _json
    end

    private

    def method_missing(symbol, *)
      if _json.key?(symbol.to_s)
        _as_resource(_json.public_send(:[], symbol.to_s, *))
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
        json.map { |j| _as_resource(j) }.freeze
      else
        json.freeze
      end
    end
  end
end
