module UploadValidations
  class Base
    def is_integer?(value)
      /\A\d+\z/ === value
    end

    def validate_required_columns
      raise BadRequest.new('Missing columns in uploaded file') unless required_columns.subset?(file_headers)
    end

    private

    def file_headers
      []
    end
  end
end