class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if user = User.find_by(email: params[:email])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: "If that email address is in our system, a reset link is on its way."
  end

  def edit
  end

  def update
    if @user.update(password_params)
      redirect_to new_session_path, notice: "Password reset. Please sign in with your new password."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_token_for(:password_reset, params[:token])
    redirect_to new_password_path, alert: "That password reset link is invalid or has expired." unless @user
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end