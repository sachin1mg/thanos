module Concerns::ErrorHandlers
  extend ::ActiveSupport::Concern

  def render_unauthorized(err)
    api_render json: json_error(err.message), status: :unauthorized, is_success: false
  end

  def render_unprocessable_entity(err)
    api_render json: json_error(err.message), status: :unprocessable_entity, is_success: false
  end

  def render_bad_request(err)
    api_render json: json_error(err.message), status: :bad_request, is_success: false
  end

  def render_not_found(err)
    api_render json: json_error(err.message), status: :not_found, is_success: false
  end

  def render_not_acceptable(err)
    api_render json: json_error(err.message), status: :not_acceptable, is_success: false
  end

  def render_forbidden(err)
    api_render json: json_error(err.message), status: :forbidden, is_success: false
  end

  def render_service_not_available(err)
    api_render json: json_error(err.message), status: :service_unavailable, is_success: false
  end

  def render_validation_failed(err)
    errors = []
    errors << err.as_json
    api_render json: errors, status: :unprocessable_entity, is_success: false
  end

  def render_validations_failed(err)
    api_render json: err.as_json, status: :unprocessable_entity, is_success: false
  end

  private

  #
  # Create json error for given message
  # @param message [String] Error Message
  #
  # @return [Array] Json Body
  def json_error(message)
    [{ message: message }]
  end
end
