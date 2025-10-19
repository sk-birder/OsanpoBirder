class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user
  
  def create
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new(post_comment_params)
    @post_comment.post_id = @post.id
    @post_comment.user_id = current_user.id
    if @post_comment.save
      flash[:notice_of_comment] = 'コメントに成功しました。'
      @post_comment = PostComment.new
    else
      if post_comment_params[:body].length == 0 
        flash[:notice_of_comment] = 'コメントを入力してください。'
      else
        flash[:notice_of_comment] = '文字数オーバーです。'
      end
    end
    # 再表示に必要なインスタンス変数の宣言
    @comments = PostComment.where(post_id: params[:post_id])
  end

  def destroy
    comment = PostComment.find(params[:id])
    if comment.user_id == current_user.id
      comment.destroy # コメントしたユーザーでない場合は実行しない
      flash[:notice_of_comment] = 'コメントを削除しました。'
    end
    # 再表示に必要なインスタンス変数の宣言
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new
    @comments = PostComment.where(post_id: params[:post_id])
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:body)
  end
end
