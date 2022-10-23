class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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

  def pundit_user
    UserContext.new(current_user, cookies, params[:pincode])
  end

  private

  def user_not_authorized
    flash[:alert] = t("pundit.not_authorized")
    redirect_back(fallback_location: root_path)
  end
end
