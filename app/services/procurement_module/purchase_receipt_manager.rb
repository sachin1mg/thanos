module ProcurementModule
  #
  # This class is responsible for actions related to Purchase order items
  #
  class PurchaseReceiptManager
    
    #
    # This function verifies the uploaded data with the existing purchase orders in the system
    # It returns a hash having information regarding extra and deficient sku quantities
    # @param purchase_order_ids [Array] Array of purchase_order_ids for which the 
    #                                   upload is initiated
    # @param sku_quantities [Array] Array of hashes having info about sku and quantities
    #                               [ { sku_id: 123, quantity: 100 } ]
    #
    def self.verify_uploaded_data(purchase_order_ids:, sku_quantities:)
      result = {
        unavailable: [],
        shortages: [],
        extra: [],
        not_in_po: [],
        fulfilled: []
      }

      sku_quantities.each do |data|
        sku = Sku.find_by(id: data[:sku_id])
        result[:unavailable] << data and next unless sku.present?

        purchase_order_items = PurchaseOrderItem.where(sku: sku, purchase_order_id: purchase_order_ids)
        result[:not_in_po] << data and next unless purchase_order_items.present?

        received_quantity = data[:quantity]
        ordered_quantity = purchase_order_items.where(status: :draft).sum(:quantity)
        
        result[:fulfilled] << { sku_id: sku.id, quantity: [ordered_quantity, received_quantity].min }
        if ordered_quantity < received_quantity
          result[:extra] << { sku_id: sku.id, quantity: received_quantity - ordered_quantity }
        elsif ordered_quantity > received_quantity
          result[:shortages] << { sku_id: sku.id, quantity: ordered_quantity - received_quantity }
        end
      end

      return result
    end

    #
    # This function parses the uploaded CSV file and validates the data with existing purchase orders in the system
    # @param purchase_order_ids [Array] Array of purchase_order_ids for which the 
    #                                   upload is initiated
    # @param file [Rack::Test::UploadedFile] Uploaded CSV file
    #
    def self.validate_csv(purchase_order_ids:, file:)
      sku_quantities = []
      CSV.foreach(file.path, headers: true) do |row|
        sku_quantities << { sku_id: row['Sku ID'].to_i, quantity: row['Quantity'].to_i }
      end

      verify_uploaded_data(purchase_order_ids: purchase_order_ids, sku_quantities: sku_quantities)
    end
  end
end
