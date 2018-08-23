module ProcurementModule
  #
  # This class contains all the bussiness logic regarding creation, updation
  # and other operations related to purchase_orders
  #
  # @author [Viren Chugh]
  #
  class PurchaseOrdersManager

    #
    # Initializer method
    # @param purchase_orders [Array of PurchaseOrder instances]
    #
    def initialize(purchase_orders)
      self.purchase_orders = purchase_orders
    end
    #
    # @param purchase_orders [PurchaseOrder::ActiveRecord_Relation] Purchase Orders for which csv is required
    # @param csv_options [Hash] Extra options for downloading csv
    # @return [String] CSV String generated
    #

    def index_csv(csv_options = {})
      CSV.generate(csv_options) do |csv|
        csv << ['ID', 'Supplier', 'Company', 'Item Name', 'Pack', 'Quantity']
        PurchaseOrderItem.where(purchase_order_id: purchase_orders.ids).each do |purchase_order_item|
          sku = purchase_order_item.sku
          csv << [purchase_order_item.purchase_order_id, purchase_order_item.purchase_order.supplier_id,
                  sku.manufacturer_name, sku.sku_name, sku.pack_size, purchase_order_item.quantity]
        end
      end
    end

    private

    attr_accessor :purchase_orders
  end
end
