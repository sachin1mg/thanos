module SalesOrderModule
  #
  # This class is responsible for managing sales orders
  #
  # @author[virenchugh]
  #
  class SalesOrderManager
    attr_accessor :sales_order

    #
    # @param order [Order instance]
    #
    def initialize(sales_order)
      self.sales_order = sales_order
    end

    def self.create!(create_params)
      sales_order_items = create_params[:sales_order_items]
      sales_order = SalesOrder.new(create_params.except(:sales_order_items))

      sales_order_manager = self.new(sales_order)
      sales_order_manager.validate
      sales_order_manager.save!(sales_order_items)
      sales_order
    end

    def save!(sales_order_items)
      ActiveRecord::Base.transaction do
        sales_order.save!
        create_order_items(sales_order_items)
      end
    end

    def create_order_items(sales_order_items)
      mr_sku_quantity = []
      sales_order_items.each do |item|
        sku_id = item[:sku_id]
        quantity = item[:quantity]

        sales_order_item = sales_order.sales_order_items.create!(quantity: quantity,
                                                                 sku_id: item[:sku_id],
                                                                 price: item[:price],
                                                                 discount: item[:discount])

        available_inventories = Inventory.joins(:batch).available.where(sku_id: sku_id).order('batches.expiry_date')

        available_inventories.each do |available_inventory|
          satisfied_quantity = [available_inventory.quantity, quantity].min
          sales_order_item.inventory_pickups.create!(quantity: satisfied_quantity,
                                                     inventory: available_inventory)

          ActiveRecord::Base.connection.execute("update inventories set quantity = quantity - #{satisfied_quantity},
                                                 blocked_quantity = blocked_quantity + #{satisfied_quantity} where id = #{available_inventory.id}")

          quantity -= satisfied_quantity
          break if quantity == 0
        end

        if quantity > 0
          mr_sku_quantity.push({ sku_id: sku_id, quantity: quantity })
        end
      end

      create_material_request(mr_sku_quantity) if mr_sku_quantity.present?
    end

    def create_material_request(mr_sku_quantity)
      # TODO KAMAL
      # ProcurementModule::MaterialRequestManager.create!(type: :jit,
      #                                                   sales_order: sales_order,
      #                                                   skus: mr_sku_quantity)
    end

    #
    # Validations for sales order before saving
    #
    def validate
      ::SalesOrderModule::Validations::SalesOrderValidation.new(sales_order).validate
    end
  end
end