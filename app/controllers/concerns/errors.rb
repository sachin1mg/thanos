module Concerns::Errors
  extend ::ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from RailsParam::Param::InvalidParameterError, with: :render_bad_request

    rescue_from ::Unauthorized, with: :render_unauthorized
    rescue_from ::BadRequest, with: :render_bad_request
    rescue_from ::Forbidden, with: :render_forbidden
    rescue_from ::ValidationFailed, with: :render_validation_failed
    rescue_from ::ValidationsFailed, with: :render_validations_failed
    rescue_from InterService::Model::RecordNotFound, with: :render_not_found
    rescue_from InterService::Model::InvalidRequest, with: :render_bad_request
    rescue_from InterService::Model::RecordNotSaved, with: :render_unprocessable_entity
  end
end
