module ProcurementModule
  class MaterialRequestsManager
    def initialize(material_requests)
      self.material_requests = material_requests
    end

    def self.create!(user:, vendor:, skus_params: [])
      material_requests = []

      skus_params.each do |sku_params|
        mr_po_mapping = MaterialRequest.where(vendor: vendor, sku_id: sku_params['sku_id'], status: :created).first&.mr_po_mapping
        mr_po_mapping = MrPoMapping.create! if mr_po_mapping.blank?

        material_request = MaterialRequest.new(user: user,
                                               vendor: vendor,
                                               sku_id: sku_params['sku_id'],
                                               quantity: sku_params['quantity'],
                                               sales_order_item_id: sku_params['sales_order_item_id'],
                                               mr_po_mapping: mr_po_mapping)

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
