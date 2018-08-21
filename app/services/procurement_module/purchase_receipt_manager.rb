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

        # TODO [nipunmanocha] Check for status here and corresponding changes in specs also
        purchase_order_items = PurchaseOrderItem.where(sku: sku, purchase_order_id: purchase_order_ids)
        result[:not_in_po] << data and next unless purchase_order_items.present?

        given_quantity = data[:quantity]
        desired_quantity = purchase_order_items.sum(:quantity)
        
        if desired_quantity === given_quantity
          result[:fulfilled] << { sku_id: sku.id, quantity: desired_quantity }
        elsif desired_quantity < given_quantity
          result[:fulfilled] << { sku_id: sku.id, quantity: desired_quantity }
          result[:extra] << { sku_id: sku.id, quantity: given_quantity - desired_quantity }
        else
          result[:fulfilled] << { sku_id: sku.id, quantity: given_quantity }
          result[:shortages] << { sku_id: sku.id, quantity: desired_quantity - given_quantity }
        end
      end

      return result
    end
  end
end
