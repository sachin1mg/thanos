class VendorSerializer < ApplicationSerializer
  attributes :id, :name, :status, :metadata, :invoice_number_template, :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :name, :status, :metadata, :invoice_number_template, :created_at, :updated_at]
  end
end



