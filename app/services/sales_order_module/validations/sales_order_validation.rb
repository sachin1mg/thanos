module SalesOrderModule::Validations
  #
  # This class is responsible for Sales Order validations
  #
  # @author [virenchugh]
  #
  class SalesOrderValidation
    attr_accessor :sales_order

    #
    # @param sales order[Sales Order instance]
    #
    def initialize(sales_order)
      raise BadRequest.new('sales_order is required') unless sales_order.present?
      self.sales_order = sales_order
    end

    #
    # Run set of validation suite
    #
    def validate(sku_ids)
      validate_vendor
      validate_skus(sku_ids)
    end

    def validate_vendor
      # validate if Vendor is active
      if sales_order.vendor.blank? || sales_order.vendor.inactive?
        raise ::ValidationFailed.new('Invalid vendor')
      end
    end

    def validate_skus(sku_ids)
      raise ::ValidationFailed.new('Invalid skus') if Sku.where(id: sku_ids).count != sku_ids.count
    end
  end
end
