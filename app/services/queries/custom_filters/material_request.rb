module Queries::CustomFilters
  class MaterialRequest < ::Queries::Filters
    #
    # @param from_delivery_date [Date]
    #
    def from_delivery_date(from_delivery_date)
     scope.where('material_requests.delivery_date >= ?', from_delivery_date)
    end

    #
    # @param to_delivery_date [Date]
    #
    def to_delivery_date(to_delivery_date)
     scope.where('material_requests.delivery_date <= ?', to_delivery_date)
    end

    #
    # @param ids [Array] Ids of material request
    #
    def ids(ids)
      where_query = ids.map { |id| "material_requests.id::text like '%#{id}%'" }
      scope.where(where_query.join(' OR '))
    end

    #
    # @param sales_order_id [Integer] Id of Sales Order
    #
    def sales_order_id(sales_order_id)
      scope.joins(:sales_order_item).where("sales_order_items.sales_order_id::text like '%#{sales_order_id}%'")
    end

    #
    # @param order_reference_id [String]
    #
    def order_reference_id(order_reference_id)
      scope.joins(sales_order_item: :sales_order).where("sales_orders.order_reference_id::text like '%#{order_reference_id}%'")
    end
  end
end
