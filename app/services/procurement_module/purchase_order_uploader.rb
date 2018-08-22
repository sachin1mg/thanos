module ProcurementModule
  #
  # This class is responsible for uploading purchase order
  #
  # @author[virenchugh]
  #
  class PurchaseOrderUploader
    attr_accessor :file, :user, :raise_error

    #
    # Initializer method
    # @param file [ActionDispatch::Http::UploadedFile instance]
    #
    def initialize(file:, user:, raise_error:)
      raise BadRequest.new('Need user to be present') unless user.present?
      raise BadRequest.new('Need file to be present') unless file.present?
      raise BadRequest.new('File should be CSV format') if file.path.split('.').last.downcase != 'csv'

      self.file = file
      self.user = user
      self.raise_error = raise_error
    end

    def validate_and_upload
      validate
      temp_file = File.open("/tmp/purchase_order_#{user.id}_#{Time.zone.now}.csv", "w")
      temp_file.write(file.read)
      file_path = temp_file.path
      temp_file.close

      ProcurementModule::PurchaseOrderUploadWorker.perform_async(user.id, file_path, raise_error)
    end

    #
    # Validate Orders Csv File
    #
    def validate
      ::UploadValidations::PurchaseOrderValidation.new(file).validate(raise_error: raise_error)
    end

    def upload
      invalid_values = validate
      ActiveRecord::Base.transaction do
        upload_purchase_order(invalid_values)
      end
    end

    private

    def upload_purchase_order(invalid_values = {})
      supplier_po_mapping = {}
      purchase_order_items = []

      CSV.foreach(file.path, headers: true) do |row|
        supplier_id = row['Supplier Id'].to_i
        code = row['Code'].to_i
        sku_id = row['Item Code'].to_i
        quantity = row['Shortage'].to_i

        if raise_error.blank? && (invalid_values[:missing_supplier_ids].include?(supplier_id) ||
        invalid_values[:missing_sku_ids].include?(sku_id) || invalid_values[:missing_material_request_ids].include?(code))
           next
        end

        if supplier_id.present? && quantity > 0
          purchase_order_id = supplier_po_mapping[supplier_id].presence ||
                              PurchaseOrder.create!(user: user,
                                                    vendor: user.vendor,
                                                    supplier_id: supplier_id,
                                                    type: code.present? ? :jit : :bulk).id
          supplier_po_mapping[supplier_id] = purchase_order_id

          purchase_order_items.append(quantity: quantity,
                                      sku_id: sku_id,
                                      material_request_id: code,
                                      purchase_order_id: purchase_order_id)
        else
          #TODO pushback logic
        end
      end
      PurchaseOrderItem.import!(purchase_order_items, validate: true)
    end
  end
end
