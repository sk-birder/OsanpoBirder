class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user
  
  def index
  end

  def create
    byebug
    post = Post.find(params[:post_id])
    comment = PostComment.new(comment_params)
    comment.post_id = post.id
    comment.poster_id = current_user.id
    comment.is_admin = false
    byebug
    if comment.save
      flash[:notice] = 'コメントに成功しました。'
    else
      flash[:notice] = 'コメントに失敗しました。'
    end
    redirect_to post_path(post)
  end

  def destroy
    comment = PostComment.find(params[:id])
    if comment.poster_id == current_user.id
      comment.destroy # コメントしたユーザーでない場合は実行しない
      flash[:notice] = 'コメントを削除しました。'
    end
    redirect_to post_path(params[:post_id])
  end


  private
  def comment_params
    params.require(:post_comment).permit(:body)
  end
end
