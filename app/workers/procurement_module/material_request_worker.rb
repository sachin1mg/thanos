module ProcurementModule
  class MaterialRequestWorker
    include Sidekiq::Worker

    sidekiq_options queue: 'low', retry: 3

    #
    # @param user_id [Integer] Required
    # @param vendor_id [Integer] Required
    # @param sku_params [Hash]
    #
    def perform(user_id, vendor_id, sku_params)
      user = User.find(user_id)
      vendor = Vendor.find(vendor_id)
      sku_params = JSON.parse(sku_params)

      ProcurementModule::MaterialRequestsManager.create!(user: user,
                                                         vendor: vendor,
                                                         skus_params: sku_params)
    end
  end
end
