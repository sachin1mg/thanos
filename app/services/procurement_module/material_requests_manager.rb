module ProcurementModule
  #
  # This class contains all the bussiness logic regarding creation, updation
  # and other operations related to material_requests
  #
  # @author [Viren Chugh]
  #
  class MaterialRequestsManager

    #
    # Initializer method
    # @param material_requests [Array of MaterialRequest instances]
    #
    def initialize(material_requests)
      self.material_requests = material_requests
    end
    #
    # @param material_requests [MaterialRequest::ActiveRecord_Relation] Material Requests for which csv is required
    # @param csv_options [Hash] Extra options for downloading csv
    # @return [String] CSV String generated
    #
    def index_csv(csv_options = {})
      CSV.generate(csv_options) do |csv|
        csv << ['ID', 'Company', 'Item Name', 'Pack', 'Shortage']
        material_requests.each do |material_request|
          sku = material_request.sku
          csv << [material_request.id, sku.manufacturer_name, sku.sku_name, sku.pack_size,
                  material_request.quantity]
        end
      end
    end

    private

    attr_accessor :material_requests
  end
end
