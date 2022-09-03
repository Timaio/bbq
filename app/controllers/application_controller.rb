class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user_can_edit?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, 
      keys: %i[password password_confirmation current_password])
  end

  def current_user_can_edit?(resource)
    user_signed_in? && (
      resource.user == current_user || (
        resource.try(:event).present? && 
        resource.event.user == current_user
      )
    )
  end
end
