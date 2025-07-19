class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where('user_id = ?', params[:id])
  end

  def edit
  end

  def banish
    byebug
    redirect_to admin_user_path(params[:id])
  end
end
