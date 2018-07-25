module InterService::Model
  #
  # Base error class
  #
  # @author [rohitjangid]
  #
  class Base < StandardError
    def initialize(service_name, msg)
      self.service_name = service_name
      self.msg = msg
      super(msg)
    end

    def to_s
      "#{service_name} - #{msg}"
    end

    private

    attr_accessor :service_name, :msg
  end

  class RecordNotFound < Base
  end

  class RecordNotSaved < Base
  end

  class InvalidRequest < Base
  end

  class ServerError < Base
  end
end
