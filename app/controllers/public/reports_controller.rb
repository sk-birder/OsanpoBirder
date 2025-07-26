class Public::ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user

  def create
    post = Post.find(params[:post_id])
    report = current_user.reports.new(post_id: post.id, detail: params[:detail])
    report.save
    redirect_to post_path(post)
  end

  def update
    post = Post.find(params[:post_id])
    report = current_user.reports.find_by(post_id: post.id)
    report.update(detail: params[:detail])
    redirect_to post_path(post)
  end

  def destroy
    post = Post.find(params[:post_id])
    report = current_user.reports.find_by(post_id: post.id)
    report.destroy
    redirect_to post_path(post)
  end
end
