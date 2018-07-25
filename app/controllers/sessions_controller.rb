class SessionsController < Devise::SessionsController
  def create
    user = User.find_by_email(params[:email])

    if user && user.valid_password?(params[:password])
      api_render json: {
        token: user.generate_jwt
      }
    else
      raise BadRequest.new('Email or password is invalid')
    end
  end

  private

  def valid_create?
    param! :email, String, required: true, blank: false
    param! :password, String, required: true, blank: false
  end
end