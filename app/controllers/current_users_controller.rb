class CurrentUsersController < ApplicationController
  def update
    user = User.find_by(id: params[:user_id])

    if user
      session[:current_user_id] = user.id
      flash[:notice] = "You are now acting as #{user.name}."
    else
      flash[:alert] = "Select a valid user."
    end

    redirect_back fallback_location: root_path
  end
end