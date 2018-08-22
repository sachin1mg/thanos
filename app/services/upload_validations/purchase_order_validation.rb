module UploadValidations
  class PurchaseOrderValidation < Base

    #
    # @param [Hash]
    #
    def initialize(file)
      self.file_headers = Set.new(CSV.open(file.path, &:readline))
      self.file = file
    end

    #
    # Run set of validation suite
    #
    def validate(raise_error:)
      validate_required_columns

      errors = []
      supplier_ids = []
      sku_ids = []
      material_request_ids = []
      invalid_shortage_rows = []
      CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
        supplier_ids.append(row['Supplier Id'].to_i)
        sku_ids.append(row['Item Code'].to_i)
        material_request_ids.append(row['Code'].nil? ? nil : row['Code'].to_i)
        invalid_shortage_rows << validate_shortage(row, index)
      end

      invalid_shortage_rows = invalid_shortage_rows.compact
      missing_sku_ids = validate_skus(sku_ids.uniq)
      missing_supplier_ids = validate_suppliers(supplier_ids.uniq)
      missing_material_request_ids = validate_material_requests(material_request_ids.compact)

      if raise_error
        errors << "Invalid Item Codes #{missing_sku_ids.join(', ')}" if missing_sku_ids.present?
        errors << "Invalid supplier ids #{missing_supplier_ids.join(', ')}" if missing_supplier_ids.present?
        errors << "Invalid material request codes #{missing_material_request_ids.join(', ')}" if missing_material_request_ids.present?
        errors << "Invalid shortages at rows #{invalid_shortage_rows.join(', ')}" if invalid_shortage_rows.present?
        raise BadRequest.new(errors.join(' || ')) unless errors.empty?
      else
        return {
                  missing_sku_ids: missing_sku_ids,
                  missing_supplier_ids: missing_supplier_ids,
                  missing_material_request_ids: missing_material_request_ids
               }
      end
    end

    private

    attr_accessor :file_headers, :file

    #
    # Validates if sku is present
    #
    def validate_skus(sku_ids)
      skus = Sku.where(id: sku_ids)
      missing_sku_ids = sku_ids - skus.ids
      return missing_sku_ids
    end

    #
    # Validates if suppliers are active
    #
    def validate_suppliers(supplier_ids)
      suppliers = Supplier.where(id: supplier_ids)
      missing_supplier_ids = supplier_ids - suppliers.ids
      return missing_supplier_ids
    end

    #
    # Validates if material requests are downloaded
    #
    def validate_material_requests(material_request_ids)
      material_requests = MaterialRequest.where(id: material_request_ids, status: :downloaded)
      missing_material_request_ids = material_request_ids - material_requests.ids
      return missing_material_request_ids
    end

    #
    # Validates shortage value
    #
    def validate_shortage(row, index)
      shortage = row['Shortage']

      if !is_integer?(shortage) || shortage.to_i <= 0
        return index
      else
        return nil
      end
    end

    def required_columns
      Set['Code', 'Company', 'Item Code', 'Item Name', 'Pack', 'Ordered Qty',
          'Available Qty', 'Shortage', 'Mrp',	'Location', 'Supplier Id']
    end
  end
end