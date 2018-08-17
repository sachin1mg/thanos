module Queries::CustomFilters
  class PurchaseOrder < ::Queries::Filters
    #
    # @param from_created_date [Date]
    #
    def created_from(created_from)
      scope.where('purchase_orders.created_at >= ?', created_from)
    end

    #
    # @param to_created_date [Date]
    #
    def created_to(created_to)
      scope.where('purchase_orders.created_at <= ?', created_to)
    end

    #
    # @param supplier_name [String]
    #
    def supplier_name(supplier_name)
      scope.joins(:supplier).where('suppliers.name like ?', "%#{supplier_name}%")
    end
  end
end
