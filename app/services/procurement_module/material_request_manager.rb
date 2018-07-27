module ProcurementModule
  class MaterialRequestManager

    def self.create!(type:, sales_order:, skus: [])
      material_request = MaterialRequest.create!(
        type: type,
        sales_order: sales_order,
        vendor: sales_order.vendor
      )
      MaterialRequestItemManager.create_bulk!(material_request, skus)
    end
  end
end
