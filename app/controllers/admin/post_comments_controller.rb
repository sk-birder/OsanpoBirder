class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

  def index
    @comments = PostComment.all
  end

  def destroy
    post_comment = PostComment.find(params[:id])
    post_comment.destroy
    flash[:notice] = 'コメントを削除しました。'
    redirect_back fallback_location: admin_root_path
  end
end
