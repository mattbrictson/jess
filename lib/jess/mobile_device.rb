require "forwardable"

module Jess
  # A Mobile Device record returned from JSS. The data mirrors the structure of
  # the JSS Mobile Device JSON representation, with sections for general,
  # security, extension attributes, etc.
  class MobileDevice < Resource
    extend Forwardable
    def_delegators :general, :id, :name

    def extension_attributes
      @ext_attrs ||= ExtensionAttributes.new(_json["extension_attributes"])
    end

    def inspect
      "Jess::MobileDevice<##{id}, #{name}>"
    end
  end
end
