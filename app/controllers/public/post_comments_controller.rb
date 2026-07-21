class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user
  before_action :set_post
  
  def create
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
    @comments = PostComment.where(post_id: params[:post_id]).recent
  end

  def destroy
    comment = PostComment.find_by(id: params[:id], user_id: current_user.id)
    if comment&.destroy
      flash[:notice_of_comment] = 'コメントを削除しました。'
    else
      flash[:notice_of_comment] = 'コメントが存在しないか、削除できません。'
    end
    # 再表示に必要なインスタンス変数の宣言
    @post_comment = PostComment.new
    @comments = PostComment.where(post_id: params[:post_id]).recent
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:body)
  end

  def set_post
    @post = Post.find_by(id: params[:post_id]) # インスタンス変数で宣言するのはjQueryでの部分テンプレート呼出時に必要なため
    if @post.blank?
      flash[:alert] = 'コメント対象の投稿が削除されています。'
      redirect_to root_path
    end
  end
end
