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
        hash[attr["name"]] = attr["value"]
      end
      @values.freeze
    end

    # Explicitly delegate instead of using def_delegators in order to be
    # compatible with awesome_print. The original Hash#to_hash method is
    # implemented in C, which means it has an arity of -1. This confuses
    # awesome_print.
    def to_hash
      @values.to_hash
    end
  end
end
