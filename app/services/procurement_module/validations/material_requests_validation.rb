module ProcurementModule::Validations
  #
  # This class is responsible for Material Request validations
  #
  # @author [virenchugh]
  #
  class MaterialRequestsValidation

    #
    # @param material_request[Material Request instance]
    #
    def initialize(material_requests)
      raise BadRequest.new('material_requests is required') unless material_requests.present?
      self.material_requests = material_requests
    end

    #
    # Run set of validation suite
    #
    def validate(sales_order_item_ids)
      sku_ids = material_requests.pluck(:sku_id)
      vendor = material_requests.first.vendor

      validate_vendor(vendor)
      validate_skus(sku_ids)
      validate_sales_order_items(sales_order_item_ids)
    end

    private

    attr_accessor :material_requests

    def validate_vendor(vendor)
      # validate if Vendor is active
      if vendor.blank? || vendor.inactive?
        raise ::ValidationFailed.new('Invalid vendor')
      end
    end

    def validate_skus(sku_ids)
      raise ::ValidationFailed.new('Invalid skus') if Sku.where(id: sku_ids).count != sku_ids.count
    end

    def validate_sales_order_items(sales_order_item_ids)
      if SalesOrderItem.where(id: sales_order_item_ids).count != sales_order_item_ids.count
        raise ::ValidationFailed.new('Invalid sales order items') 
      end
    end
  end
end
