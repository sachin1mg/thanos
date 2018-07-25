class AuthController < BaseController
  before_action :authenticate_user!

  private

  def authenticate_user!
    raise ::Unauthorized if current_user.id.blank?
  end
end
