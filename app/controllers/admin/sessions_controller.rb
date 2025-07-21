# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  # is_active, is_forbiddenの判定
  before_action :admin_status, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

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

  protected
  def after_sign_in_path_for(resource)
    admin_root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private
  # is_active, is_forbiddenの判定用メソッド
  def admin_status
    # 入力されたメールアドレスがUserテーブルにあるか確認して、無ければdeviseに返して拒否してもらう
    admin = Admin.find_by(email: params[:admin][:email])
    return if admin.nil?
    # パスワードが一致しているか確認して、無ければdeviseに返して拒否してもらう
    return unless admin.valid_password?(params[:admin][:password])
    # is_forbiddenがtrueのときdeviseの処理を中断してサインアップ画面に遷移する
    if admin.is_forbidden == true || admin.is_active == false
      if admin.is_forbidden == true
        flash[:notice] = '除名済みの管理者です。'
      else
        flash[:notice] = '退会済みの管理者です。'
      end
      redirect_to root_path
    end
  end

end
