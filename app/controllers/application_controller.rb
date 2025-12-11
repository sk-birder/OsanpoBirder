class ApplicationController < ActionController::Base
  # エンドユーザーの除名・退会判定
  def deny_deactivated_user
    return if current_user.is_active
    flash[:notice] = current_user.is_forbidden ? '除名済みのアカウントです。' : '退会済みのアカウントです。'
    sign_out(current_user)
    redirect_to new_user_registration_path
  end
 
  # 管理者の除名・退会判定
  def deny_deactivated_admin
    return if current_admin.is_active
    flash[:notice] = current_admin.is_forbidden ? '除名済みの管理者です。' : '退会済みの管理者です。'
    sign_out(current_admin)
    redirect_to root_path
  end
end
