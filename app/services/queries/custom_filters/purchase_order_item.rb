module Queries::CustomFilters
  class PurchaseOrderItem < ::Queries::Filters
   #
   # @param from_schedule_date [Date]
   #
   def from_schedule_date(from_schedule_date)
    scope.where('purchase_order_items.schedule_date >= ?', from_schedule_date)
   end

   #
   # @param to_schedule_date [Date]
   #
   def to_schedule_date(to_schedule_date)
    scope.where('purchase_order_items.schedule_date <= ?', to_schedule_date)
   end

   #
   # @param minimum_price [Date]
   #
   def minimum_price(minimum_price)
    scope.where('purchase_order_items.price >= ?', minimum_price)
   end

   #
   # @param maximum_price [Date]
   #
   def maximum_price(maximum_price)
    scope.where('purchase_order_items.price <= ?', maximum_price)
   end
  end
end
