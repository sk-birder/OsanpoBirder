class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where('user_id = ?', params[:id])
  end

  def edit
  end

  # 退会の代行・取消
  def toggle_activity
    user = User.find(params[:id])
    user.toggle(:is_active).save
    redirect_to admin_user_path(params[:id])
  end

  # 除名
  def banish
    user = User.find(params[:id])
    # ステータスの変更
    user.update(is_active: false)
    user.update(is_forbidden: true)
    # 投稿削除
    Post.where('user_id = ?', user.id).destroy_all
    PostComment.where('user_id = ?', user.id).destroy_all
    redirect_to admin_user_path(params[:id])
  end

  # テスト用
  # def activate_all
  #   users = User.all
  #   users.each do |user|
  #     user.update(is_active: true)
  #     user.update(is_forbidden: false)
  #   end
  #   redirect_to admin_users_path
  # end
end
