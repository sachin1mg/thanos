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
  end
end