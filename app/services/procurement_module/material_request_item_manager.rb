module ProcurementModule
  class MaterialRequestItemManager

    def self.create_bulk!(material_request, skus)
      skus.each do |sku|
        material_request.material_request_items.create!(
          sku_id: sku[:sku_id],
          quantity: sku[:quantity]
        )
      end
    end
  end
end
