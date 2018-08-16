module ProcurementModule
  class PurchaseOrderManager

    attr_accessor :purchase_order

    def initialize(purchase_order)
      self.purchase_order = purchase_order
    end

    def self.create!(user: , params:)
      vendor = user.vendor
      purchase_order_items = []

      ActiveRecord::Base.transaction do
        purchase_order = vendor.purchase_orders.create!(params.except(:purchase_order_items).merge({type: 'bulk', user: user}))
        params[:purchase_order_items].each do |param|
          purchase_order_items << purchase_order.purchase_order_items.new(param)
        end

        PurchaseOrderItem.import!(purchase_order_items, validate: true)
        purchase_order
      end
    end

    def update(params)
      if params[:status] == 'cancelled'
        purchase_order.cancel!
      elsif params[:status] == 'closed'
        purchase_order.close!
      end

      purchase_order
    end
  end
end
