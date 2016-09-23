require "forwardable"

module Jess
  # A Hash-like wrapper around the extension attributes that facilitates easy
  # key/value access.
  class ExtensionAttributes < Resource
    extend Forwardable
    def_delegators :@values, :[], :fetch, :key?, :keys, :size, :length, :to_h

    def initialize(json)
      super
      @values = json.each_with_object({}) do |attr, hash|
        hash[attr.name] = attr.value
      end
      @values.freeze
    end
  end
end
