module ProcurementModule
  class MaterialRequestsManager
    def initialize(material_requests)
      self.material_requests = material_requests
    end

    def self.create!(user:, vendor:, skus_params: [])
      material_requests = []

      skus_params.each do |sku_params|
        material_request = MaterialRequest.find_or_initialize_by(status: :created, vendor: vendor, sku_id: sku_params['sku_id'])

        if material_request.new_record?
          material_request.user = user
          material_request.sales_order_item_ids = [sku_params['sales_order_item_id']]
          material_request.quantity = sku_params['quantity']
        else
          material_request.sales_order_item_ids.append(sku_params['sales_order_item_id'])
          material_request.quantity += sku_params['quantity']
        end
        material_requests << material_request
      end

      material_requests_manager = self.new(material_requests)
      material_requests_manager.save!(skus_params)
    end

    def save!(skus_params)
      validate(skus_params)
      material_requests.each(&:save!)
    end

    private

    attr_accessor :material_requests

    #
    # Validations for material requests
    #
    def validate(skus_params)
      ::ProcurementModule::Validations::MaterialRequestsValidation.new(material_requests).validate(skus_params)
    end
  end
end
