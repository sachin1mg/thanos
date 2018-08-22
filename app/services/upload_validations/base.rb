module UploadValidations
  class Base
    def is_integer?(value)
      /\A\d+\z/ === value
    end
  end
end