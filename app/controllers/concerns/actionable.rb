module Concerns::Actionable
  extend ::ActiveSupport::Concern

  included do
    before_action :set_resource, only: [:show, :edit, :update, :destroy, :perform_action] # TODO[@rohitjangid]: This needs to be improved
  end

  def perform_action
    begin
      options = self.send(params[:perform_action].to_s + '_options')
    rescue NoMethodError
      raise AbstractController::ActionNotFound.new("Invalid action: #{params[:perform_action]}")
    end
    resource_manager.perform(params[:perform_action], options)

    render_method = "#{params[:perform_action]}_render".to_sym
    if self.private_methods.include? render_method
      self.send(render_method)
    else
      redirect_back(fallback_location: url_for(resource))
    end
  end

  private

  def resource_manager
    not_implemented
  end

  def valid_perform_action?
    param! :perform_action, String, required: true, blank: false
  end
end
