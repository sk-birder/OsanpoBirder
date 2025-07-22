class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

  def index
    @posts = Post.all
  end

  def show
    @show_post = Post.find(params[:id])
    @comments = PostComment.where('post_id = ?', params[:id])
  end
end
