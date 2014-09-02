class PasswordsController < ApplicationController
  before_filter :authenticate_user!

  def update
    @user = current_user
    # raise params.inspect
    if !@user.valid_password?(user_params[:current_password])
      message = { alert: 'Current Password is incorrect.'}
    elsif @user.update_with_password(user_params)
      sign_in(@user, :bypass => true)
      message = { notice: 'Your Password has been updated.' }
    else
      if @user.errors.messages[:password]
        message = { alert: "Password was not successfully updated.  New Password #{@user.errors.messages[:password][0]}." }
      elsif @user.errors.messages[:password_confirmation]
        message = { alert: "Password was not successfully updated.  New Password #{@user.errors.messages[:password_confirmation][0]}." }
      else
        puts @user.errors.messages
        message = { alert: "Password was not successfully updated." }
      end
    end
    redirect_to my_account_path, message
  end

private

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

end