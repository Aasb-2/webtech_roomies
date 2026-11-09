class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization

  allow_browser versions: :modern
  stale_when_importmap_changes

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  helper_method :current_user

  private

  def current_user
    Current.user
  end

  def user_not_authorized
    flash[:alert] = "You don't have permission to do that."
    redirect_back fallback_location: root_path
  end

  def record_not_found
    flash[:alert] = "That page doesn't exist, or you don't have access to it."
    redirect_to root_path
  end

end