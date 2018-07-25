module Api::Public::V1
  class TestController < ::Api::Public::AuthController
    def test
      head :ok
    end

    def valid_test?

    end
  end
end