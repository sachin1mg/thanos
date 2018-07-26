class ApplicationController < ActionController::API
  include Concerns::Errors
  include Concerns::ErrorHandlers
  include Concerns::ActionValidator
  include Concerns::ThreadUserable
  include Concerns::Cacheable
  include Concerns::ParamValidator

  # before_action :authenticate_user!
  before_action :set_raven_context
  before_action :set_paper_trail_whodunnit

  def api_render(json:, meta: nil, status: :ok, root: nil, is_success: true, fields: [])
    if is_success
      data = if root.blank?
               { data: json }
             else
               { data: { root => json } }
             end
    else
      data = { errors: json }
    end
    data = data.merge({ meta: meta }) unless meta.blank?
    data = data.merge({ is_success: is_success, status_code: Rack::Utils::SYMBOL_TO_STATUS_CODE[status] })
    render json: data, status: status, fields: fields
  end

  #
  # Add extra info to lograge payload
  #
  def append_info_to_payload(payload)
    super
    payload[:request] = request
    payload[:response] = response if Settings.LOGRAGE.ENABLE_RESPONSE
  end

  def set_raven_context
    return unless signed_in?
    Raven.user_context(id: current_user.id)
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def current_user
    return unless signed_in?
    @current_user ||= User.find(@current_user_id)
  rescue ActiveRecord::RecordNotFound
    raise ::Unauthorized
  end

  def signed_in?
    @current_user_id.present?
  end

  def authenticate_user!
    token = request.headers['Authorization']
    return unless token.present?
    jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first
    @current_user_id = jwt_payload['id']
  rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
    raise ::Unauthorized
  end

  def health
    render json: {}
  end

  private

  def valid_health?
  end
end
