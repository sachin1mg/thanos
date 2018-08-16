module ProcurementModule::Validations
  #
  # This class is responsible for validating the creation of a material_request
  #
  # @author [nipunmanocha]
  #
  class MaterialRequestValidation
    #
    # @param sales_order_item [SalesOrderItem] Sales order item for which material_request is to be created
    # @param unavailable_quantity [Integer]
    #
    def initialize(sales_order_item:, unavailable_quantity:)
      self.sales_order_item = sales_order_item
      self.unavailable_quantity = unavailable_quantity
    end

    #
    # Run a set of validation suite
    #
    def validate
      validate_sales_order_item_status
      validate_unavailable_quantity
      # TODO [nipunmanocha] Validate that there is no inventory for the sku
    end

    private

    attr_accessor :sales_order_item, :unavailable_quantity

    #
    # Validate the status of sales_order_item
    #
    def validate_sales_order_item_status
      raise ValidationFailed.new('Material request cannot be created after sales order item is processed') if sales_order_item.processed?
    end

    #
    # Validate unavailable_quantity
    #
    def validate_unavailable_quantity
      raise ValidationFailed.new('Unavailable Quantity cannot be more than ordered quantity') if unavailable_quantity > sales_order_item.quantity
    end
  end
end
