module Queries::CustomFilters
  class MaterialRequest < ::Queries::Filters

    #
    # @param created_from [Date]
    #
    def created_from(created_from)
      scope.where('material_requests.created_at >= ?', created_from.to_date.beginning_of_day)
    end

    #
    # @param created_to [Date]
    #
    def created_to(created_to)
      scope.where('material_requests.created_at <= ?', created_to.to_date.end_of_day)
    end
  end
end
