class ApplicationController < ActionController::Base
  # エンドユーザーの除名・退会判定
  def deny_deactivated_user
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

  # 管理者の除名・退会判定
  def deny_deactivated_admin
    if current_admin.is_forbidden == true || current_admin.is_active == false
      if current_admin.is_forbidden == true
        flash[:notice] = '除名済みの管理者です。'
      else
        flash[:notice] = '退会済みの管理者です。'
      end
      sign_out(current_admin)
      redirect_to root_path
    end
  end

end
