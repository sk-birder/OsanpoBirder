class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

  def index
    if params[:status] == 'active'
      @users = User.active
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
      @posts = @user.posts.joins(:reports).where(reports: {detail: 'violating'}).distinct.page(params[:page])
    else
      @posts = @user.posts.page(params[:page])
    end
  end

  def comments
    @user = User.find(params[:id])
    @comments = PostComment.where(user_id: params[:id])
    # コメントの対象投稿の情報を取得 とても重いので一旦コメントアウト
    # commented_post_ids = @comments.pluck(:post_id)
    # @commented_posts = Post.where(id: commented_post_ids)
  end

  # 退会の取り消し
  def activate
    user = User.find(params[:id])
    user.update(is_active: true)
    redirect_to admin_user_path(user), notice: '退会を取り消しました。'
  end

  # 退会の代行
  def deactivate
    user = User.find(params[:id])
    user.update(is_active: false)
    destroy_all_likes_reports_relationships(user)
    redirect_to admin_user_path(user), notice: '退会させました。'
  end

  # 除名
  def banish
    user = User.find(params[:id])
    user.update(is_active: false, is_forbidden: true)
    destroy_all_likes_reports_relationships(user)
    destroy_all_posts_and_comments(user)
    redirect_to admin_user_path(params[:id]), notice: '除名しました。'
  end

  # 全投稿の管理者非公開
  def hide_all_posts
    posts = Post.where(user_id: params[:id], is_forbidden: false)
    posts.each do |post|
      post.update(is_forbidden: true)
    end
    redirect_to admin_user_path(params[:id]), notice: '全投稿を管理者非公開にしました。'
  end

  # 除名を伴わない全投稿・コメントの削除
  def only_delete_posts_and_comments
    user = User.find(params[:id])
    destroy_all_posts_and_comments(user)
    redirect_to admin_user_path(params[:id]), notice: '全投稿・コメントを削除しました。'
  end

  private
  def destroy_all_likes_reports_relationships(user)
    Relationship.where(followed_user_id: user.id).or(Relationship.where(follower_user_id: user.id)).destroy_all
    user.likes.destroy_all
    user.reports.destroy_all
  end

  def destroy_all_posts_and_comments(user)
    user.posts.destroy_all
    user.post_comments.destroy_all
  end

end
