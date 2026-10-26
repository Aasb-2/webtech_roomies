class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id]) || default_user
  end

  def default_user
    user = User.order(:id).first
    session[:current_user_id] = user&.id
    user
  end
end