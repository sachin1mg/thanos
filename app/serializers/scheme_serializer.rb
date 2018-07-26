class SchemeSerializer < ApplicationSerializer
  attributes :id, :schemable_id, :schemable_type, :name, :discount_type, :discount_units, :min_amount,
             :min_amount_type, :status, :expiry_at, :created_at, :deleted_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  #
  def self.default_attributes
    [:id, :schemable_id, :schemable_type, :name, :discount_type, :discount_units, :min_amount,
     :min_amount_type, :status, :expiry_at, :created_at, :deleted_at, :updated_at]
  end
end
