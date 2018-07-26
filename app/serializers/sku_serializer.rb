class SkuSerializer < ApplicationSerializer
  attributes :id, :onemg_sku_id, :sku_name, :manufacturer_name, :item_group,
             :uom, :pack_size, :created_at, :updated_at

  #
  # Default attributes for serializer
  #
  # @return [Array] Array of symbolize attributes
  def self.default_attributes
    [:id, :onemg_sku_id, :sku_name, :manufacturer_name, :item_group, :uom, :pack_size,
     :created_at, :updated_at]
  end
end
