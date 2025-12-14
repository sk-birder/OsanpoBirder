# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # is_active, is_forbiddenの判定
  before_action :user_status, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to posts_path, notice: 'guestuserでログインしました。'
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

  protected
  def after_sign_in_path_for(resource)
    user_root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private
  # 退会・除名判定
  def user_status
    # 入力されたメールアドレスがUserテーブルにあるか確認して、無ければdeviseに返して拒否してもらう
    user = User.find_by(email: params[:user][:email])
    return if user.nil?
    # パスワードが一致しているか確認して、無ければdeviseに返して拒否してもらう
    return unless user.valid_password?(params[:user][:password])
    # 退会・除名状態でなければdeviseに返してサインイン成立
    return if user.available?
    flash[:alert] = user.is_forbidden ? '除名済みのアカウントです。' : '退会済みのアカウントです。'
    redirect_to new_user_session_path
  end
end
