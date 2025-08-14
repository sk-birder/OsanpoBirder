class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

  def index
    @posts = Post.all
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
