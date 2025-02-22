class SessionsController < ApplicationController
  include SessionsHelper

  before_action :require_no_user, only: [ :new, :create, :verify ]

  def new
  end

  def create
    user = User.find_or_create_by(phone_number: params[:phone_number])
    if user&.valid?
      user.generate_verification_code
      puts "*" * 100
      puts user.verification_code
      puts "*" * 100
      redirect_to verify_token_path(token: generate_secure_token(user)), notice: "Verification code sent to #{user.phone_number}"
    else
      redirect_to new_user_session_path, alert: "Something went wrong."
    end
  end

  def verify
    @user = verify_secure_token(params[:token])
    unless @user
      redirect_to new_user_session_path, alert: "Invalid or expired token. Please try again."
    end
  end

  def verify_user
    @user = User.find(params[:id])
    if @user.verification_code == params[:verification_code]
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: "Verification successful. Welcome, #{@user.phone_number}!"
    else
      redirect_to new_user_session_path, alert: "Something went wrong."
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_user_session_path, notice: "Signed out successfully."
  end
end
