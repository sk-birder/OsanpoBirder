class ApplicationController < ActionController::Base
  def deny_deactivated_user
    if current_user.is_active == false
      sign_out(current_user)
      flash[:notice] = '退会済みのアカウントです。'
      redirect_to new_user_registration_path
    end
  end
end
