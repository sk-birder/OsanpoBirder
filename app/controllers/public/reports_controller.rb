class Public::ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user
  before_action :set_post

  def create
    report = current_user.reports.new(post_id: @post.id, detail: params[:detail])
    report.save
    @current_user_report_detail = report.detail
  end

  def update
    report = current_user.reports.find_by(post_id: @post.id)
    report.update(detail: params[:detail])
    @current_user_report_detail = report.detail
  end

  def destroy
    report = current_user.reports.find_by(post_id: @post.id)
    report.destroy
  end

  private
  def set_post
    @post = Post.find_by(id: params[:post_id]) # インスタンス変数で宣言するのはjQueryでの部分テンプレート呼出時に必要なため
    if @post.blank?
      flash[:alert] = '対象の投稿が削除されています。'
      redirect_to timeline_path
    end
  end
end
