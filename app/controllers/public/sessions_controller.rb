# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # is_active判定
  before_action :user_status, only: [:create]
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
    mypage_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private
  # is_active判定用のメソッド
  def user_status
    # 入力されたメールアドレスがUserテーブルにあるか確認して、無ければdeviseに返して拒否してもらう
    user = User.find_by(email: params[:user][:email])
    return if user.nil?
    # パスワードが一致しているか確認して、無ければdeviseに返して拒否してもらう
    return unless user.valid_password?(params[:user][:password])
    # is_activeがfalseのときdeviseの処理を中断してサインアップ画面に遷移する
    if user.is_active == false
      flash[:notice] = '退会済みのアカウントです。'
      redirect_to new_user_registration_path
    end
  end
end
