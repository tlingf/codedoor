class UsersController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    if current_user.update(user_params)
      flash[:notice] = 'Your information has been updated.'
      if params[:create_programmer].present?
        UserMailer.welcome_email(current_user).deliver
        redirect_to edit_user_programmer_path(@user)
      elsif params[:create_client].present?
        UserMailer.welcome_email(current_user).deliver
        redirect_to new_user_client_path(@user)
      else
        render :edit
      end
    else
      flash[:alert] = 'Your information could not be updated.'
      render :edit
    end
  end

  private

  def user_params
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
    params.require(:user).permit(:full_name, :email, :country, :state, :city, :password, :password_confirmation, :checked_terms)
  end
end
