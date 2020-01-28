# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    if params[:user][:email].nil?
      render :status => 400,
             :json => {:message => 'User request must contain the user email.'}
      return
    elsif params[:user][:password].nil?
      render :status => 400,
             :json => {:message => 'User request must contain the user password.'}
      return
    end

    if params[:user][:email]
      duplicate_user = User.find_by_email(params[:user][:email])
      unless duplicate_user.nil?
        render :status => 409,
               :json => {:message => 'Duplicate email. A user already exists with that email address.'}
        return
      end
    end

    @user = User.create(sign_up_params)

    if @user.save
      render(status: 200, json: {message: "User Successfully Created"})
    else
      render :status => 400,
             :json => {:message => @user.errors.full_messages}
    end
  end


  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
