class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

  def index
    if params[:status] == 'visible'
      posts = Post.visible
    elsif params[:status] == 'draft'
      posts = Post.user_draft.admin_allowed
    elsif params[:status] == 'forbidden'
      posts = Post.admin_forbidden
    elsif params[:status] == 'user_published' # テスト用のため削除すること
      posts = Post.user_published # テスト用のため削除すること
    else
      posts = Post.all
    end
    @posts = posts.recent.page(params[:page])
  end

  def show
    @show_post = Post.find(params[:id])
    @comments = PostComment.where(post_id: params[:id])
  end

  def toggle_publicity
    post = Post.find(params[:id])
    post.toggle(:is_forbidden).save
    redirect_back fallback_location: admin_root_path
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:notice] = '削除しました。'
    redirect_to admin_posts_path
  end
end
