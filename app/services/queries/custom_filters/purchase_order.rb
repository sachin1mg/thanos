module Queries::CustomFilters
  class PurchaseOrder < ::Queries::Filters
    #
    # @param from_created_date [Date]
    #
    def from_created_date(from_created_date)
      scope.where('purchase_orders.created_at >= ?', from_created_date)
    end

    #
    # @param to_created_date [Date]
    #
    def to_created_date(to_created_date)
      scope.where('purchase_orders.created_at <= ?', to_created_date)
    end

    #
    # @param supplier_name [String]
    #
    def supplier_name(supplier_name)
      scope.joins(:supplier).where('suppliers.name like ?', "%#{supplier_name}%")
    end
  end
end
