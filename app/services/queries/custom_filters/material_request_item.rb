module Queries::CustomFilters
  class MaterialRequestItem < ::Queries::Filters
   #
   # @param from_schedule_date [Date]
   #
   def from_schedule_date(from_schedule_date)
    scope.where('material_request_item.rb.schedule_date >= ?', from_schedule_date)
   end

   #
   # @param to_schedule_date [Date]
   #
   def to_schedule_date(to_schedule_date)
    scope.where('material_request_item.rb.schedule_date <= ?', to_schedule_date)
   end
  end
end
