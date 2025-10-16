class Public::ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user

  def create
    @post = Post.find(params[:post_id])
    report = current_user.reports.new(post_id: @post.id, detail: params[:detail])
    report.save
    # redirect_to post_path(post)
    count_and_detail
  end

  def update
    @post = Post.find(params[:post_id])
    report = current_user.reports.find_by(post_id: @post.id)
    report.update(detail: params[:detail])
    # redirect_to post_path(post)
    count_and_detail
  end

  def destroy
    @post = Post.find(params[:post_id])
    report = current_user.reports.find_by(post_id: @post.id)
    report.destroy
    # redirect_to post_path(post)
    count_and_detail
  end

  private
  def count_and_detail
    # 報告件数のカウント
    reports = @post.reports
    @count_report0 = reports.where(detail: 0).count
    @count_report1 = reports.where(detail: 1).count
    @count_report2 = reports.where(detail: 2).count
    # ログイン中のユーザーの報告の有無と報告内容の確認
    if @post.reported_by?(current_user)
      @report = current_user.reports.find_by(post_id: @post.id).detail
    end
  end
end
