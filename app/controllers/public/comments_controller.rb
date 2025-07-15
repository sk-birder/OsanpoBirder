class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user
  
  def index
  end

  def create
    post = Post.find(params[:post_id])
    comment = UserComment.new(comment_params)
    comment.user_id = current_user.id
    comment.post_id = post.id
    comment.is_public = true
    if comment.save
      flash[:notice] = 'コメントに成功しました。'
    else
      flash[:notice] = 'コメントに失敗しました。'
    end
    redirect_to post_path(post)
  end

  def destroy
  end


  private
  def comment_params
    params.require(:user_comment).permit(:body)
  end
end
