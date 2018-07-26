module Queries::CustomFilters
 class SalesOrder < ::Queries::Filters
   #
   # @param from_date [Date]
   #
   def from_date(from_date)
    scope.where('sales_orders.created_at >= ?', from_date.beginning_of_day)
   end

   #
   # @param to_date [Date]
   #
   def to_date(to_date)
    scope.where('sales_orders.created_at <= ?', to_date.end_of_day)
   end
 end
end
