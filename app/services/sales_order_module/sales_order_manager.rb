module SalesOrderModule
  #
  # This class is responsible for managing sales orders
  #
  # @author[virenchugh]
  #
  class SalesOrderManager

    #
    # @param order [Order instance]
    #
    def initialize(sales_order, user)
      self.sales_order = sales_order
      self.user = user
    end

    def self.create!(user, create_params)
      sales_order_items = create_params[:sales_order_items]
      sales_order = SalesOrder.new(create_params.except(:sales_order_items))

      sales_order_manager = self.new(sales_order, user)
      sales_order_manager.save!(sales_order_items)
      sales_order
    end

    def save!(sales_order_items)
      ActiveRecord::Base.transaction do
        sku_ids = sales_order_items.pluck(:sku_id)
        validate(sku_ids)
        sales_order.save!
        create_order_items(sales_order_items)
      end
    end

    private

    attr_accessor :sales_order, :user

    def create_order_items(sales_order_items)
      mr_sku_quantity = []
      sales_order_items.each do |item|
        sku_id = item[:sku_id]
        quantity = item[:quantity]

        sales_order_item = sales_order.sales_order_items.create!(quantity: quantity,
                                                                 sku_id: item[:sku_id],
                                                                 price: item[:price],
                                                                 discount: item[:discount])

        mr_sku_quantity.push(allocate_inventory(sku_id, sales_order_item, quantity))
      end
      mr_sku_quantity.compact!
      create_material_request(mr_sku_quantity) if mr_sku_quantity.present?
    end

    def allocate_inventory(sku_id, sales_order_item, quantity)
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

      return { sku_id: sku_id, quantity: quantity, sales_order_item_id: sales_order_item.id } if quantity > 0
      return nil
    end

    def create_material_request(mr_sku_quantity)
      ProcurementModule::MaterialRequestsManager.create!(user: user,
                                                         vendor: sales_order.vendor,
                                                         skus_params: mr_sku_quantity)
    end

    #
    # Validations for sales orders
    #
    def validate(sku_ids)
      ::SalesOrderModule::Validations::SalesOrderValidation.new(sales_order).validate(sku_ids)
    end
  end
end