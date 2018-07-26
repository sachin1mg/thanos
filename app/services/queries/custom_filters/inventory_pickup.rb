module Queries::CustomFilters
  class InventoryPickup < ::Queries::Filters
    #
    # @param sales_order_id [Integer] SalesOrder id
    #
    def sales_order_id(sales_order_id)
     scope.joins(:sales_order_item).where(sales_order_items: { sales_order_id: sales_order_id })
    end
  end
 end
 