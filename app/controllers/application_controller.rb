class ApplicationController < ActionController::Base
  def deny_deactivated_user
    # 除名・退会判定
    if current_user.is_forbidden == true || current_user.is_active == false
      if current_user.is_forbidden == true
        flash[:notice] = '除名済みのアカウントです。'
      else
        flash[:notice] = '退会済みのアカウントです。'
      end
      sign_out(current_user)
      redirect_to new_user_registration_path
    end
  end
end
