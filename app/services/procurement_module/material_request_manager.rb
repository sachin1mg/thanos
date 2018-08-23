require 'csv'

module ProcurementModule
  #
  # This class contains all the bussiness logic regarding creation, updation
  # and other operations related to material_requests
  #
  # @author [nipunmanocha]
  #
  class MaterialRequestManager

    #
    # This function is responsible for creation of MR's from the deficiency of skus
    # @param user [User] User logged in the system currently
    # @param shortages [Array] Array of hashes containing the sales_order_item_id and unavailable_quantity
    #                          Example: [ {sales_order_item_id: 3, unavailable_quantity: 10} ]
    #
    def self.create!(user:, shortages:)
      vendor = user.vendor

      ActiveRecord::Base.transaction do
        soi_mr_mappings = []
        shortages.each do |shortage|
          sales_order_item = SalesOrderItem.find(shortage[:sales_order_item_id])
          unavailable_quantity = shortage[:unavailable_quantity]
  
          ProcurementModule::Validations::MaterialRequestValidation.new(
            sales_order_item: sales_order_item, 
            unavailable_quantity: unavailable_quantity
          ).validate!
  
          material_request = MaterialRequest.find_by(vendor: vendor, sku: sales_order_item.sku, status: :created)
          material_request ||= MaterialRequest.create!(
                                user: user,
                                vendor: vendor,
                                sku: sales_order_item.sku)
          
          soi_mr_mappings << SoiMrMapping.new(sales_order_item: sales_order_item,
                                              material_request: material_request,
                                              quantity: unavailable_quantity) 
          
          material_request.quantity += unavailable_quantity
          material_request.save!
        end

        SoiMrMapping.import!(soi_mr_mappings, validate: true, on_duplicate_key_ignore: true)
      end
    end
  end
end
