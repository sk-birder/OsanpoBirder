class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

  def index
    if params[:status] == 'active'
      @users = User.where(is_active: true)
    elsif params[:status] == 'deactivated'
      @users = User.where(is_active: false, is_forbidden: false)
    elsif params[:status] == 'banned'
      @users = User.where(is_forbidden: true)
    else
      @users = User.all
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(user_id: params[:id])
  end

  def edit
  end

  def posts
    @user = User.find(params[:id])
    if params[:filter] == 'reported'
      # 違反投稿の絞り込み
      # joinsでReportモデルと結合し、whereでdetailが2の投稿を絞り込み、distinctで重複を無くしている
      @posts = @user.posts.joins(:reports).where(reports: {detail: 2}).distinct
    else
      @posts = @user.posts.all
    end
  end

  def comments
    @user = User.find(params[:id])
    @comments = PostComment.where(user_id: params[:id])
    # コメントの対象投稿の情報を取得 とても重いので一旦コメントアウト
    # commented_post_ids = @comments.pluck(:post_id)
    # @commented_posts = Post.where(id: commented_post_ids)
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
    Post.where(user_id: user.id).destroy_all
    PostComment.where(user_id: user.id).destroy_all
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
