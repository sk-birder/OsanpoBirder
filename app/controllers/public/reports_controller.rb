class Public::ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user

  def create
    @post = Post.find(params[:post_id]) # インスタンス変数で宣言するのはjQueryでの部分テンプレート呼出時に必要なため
    report = current_user.reports.new(post_id: @post.id, detail: params[:detail])
    report.save
    @current_user_report_detail = report.detail
  end

  def update
    @post = Post.find(params[:post_id]) # インスタンス変数で宣言するのはjQueryでの部分テンプレート呼出時に必要なため
    report = current_user.reports.find_by(post_id: @post.id)
    report.update(detail: params[:detail])
    @current_user_report_detail = report.detail
  end

  def destroy
    @post = Post.find(params[:post_id])
    report = current_user.reports.find_by(post_id: @post.id)
    report.destroy
  end
end
