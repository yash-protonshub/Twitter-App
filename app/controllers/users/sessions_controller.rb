# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  def create
    user = User.find_by_email(params[:user][:email])
    if user.present? && user.valid_password?(params[:user][:password])
      token = Tiddle.create_and_return_token(user, request)
      render json: { authentication_token: token }
    else
      render json: {message: "Username/Password incorrect."}, status: 422
    end
  end

  def destroy
    Tiddle.expire_token(current_user, request) if current_user
    if current_user
      render json: {message: "Signed out successfully"}, status: 200
    else
      render json: {message: "You are already signed out"}, status: 422
    end
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private

  def verify_signed_out_user
  end
end
