class Admin::ReportsController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

  def index
    reported_post_ids = Report.where(detail: 2).pluck(:post_id)
    # IDの重複を無くし、昇順に並び替える
    reported_post_ids_organized = reported_post_ids.uniq.sort
    @posts = Post.where(id: reported_post_ids_organized)
  end
end
