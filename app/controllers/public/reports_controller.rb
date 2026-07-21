class Public::ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user
  before_action :set_post

  def switch
    report = current_user.reports.find_by(post_id: @post.id)
    if report&.detail == params[:detail] # 新規作成時はreport.detailがnilのためぼっち演算子を使用
      report.destroy
    else
      current_user.reports
        .find_or_initialize_by(post_id: @post.id)
        .update(detail: params[:detail])
      @current_user_report_detail = params[:detail]
    end
  end

  private
  def set_post
    @post = Post.find_by(id: params[:post_id]) # インスタンス変数で宣言するのはjQueryでの部分テンプレート呼出時に必要なため
    if @post.blank?
      flash[:alert] = '対象の投稿が削除されています。'
      redirect_to root_path
    end
  end
end
