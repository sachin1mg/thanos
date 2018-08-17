require 'csv'

module ProcurementModule
  class PurchaseOrderManager

    attr_accessor :purchase_order

    def initialize(purchase_order)
      self.purchase_order = purchase_order
    end

    #
    # This method creates only bulk POs
    #
    def self.create!(user: , params:)
      vendor = user.vendor
      purchase_order = vendor.purchase_orders.new(params.except(:purchase_order_items).merge({type: 'bulk', user: user}))

      ActiveRecord::Base.transaction do
        purchase_order_items = []
        self.new(purchase_order).save
        params[:purchase_order_items].each do |param|
          purchase_order_items << purchase_order.purchase_order_items.new(param)
        end

        PurchaseOrderItem.import!(purchase_order_items, validate: true)
      end

      purchase_order
    end

    def update(params)
      if params[:status] == 'cancelled'
        purchase_order.cancel!
      elsif params[:status] == 'closed'
        purchase_order.close!
      end

      purchase_order
    end

    #
    # Save purchase_order.
    #
    def save
      purchase_order.save!
    end

    def to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << purchase_order.attributes.keys
        # purchase_order.each do |purchase_order|
          csv << purchase_order.attributes.values.map(&:to_s)
        # end
      end
    end
  end
end
