require "forwardable"

module Jess
  # A Computer record returned from JSS. The data mirrors the structure of the
  # JSS Computer JSON representation, with sections for general, hardware,
  # extension attributes, etc.
  class Computer < Resource
    extend Forwardable

    def_delegators :general, :id, :name

    def extension_attributes
      @ext_attrs ||= ExtensionAttributes.new(_json["extension_attributes"])
    end

    def inspect
      "Jess::Computer<##{id}, #{name}>"
    end
    alias to_s inspect
  end
end
