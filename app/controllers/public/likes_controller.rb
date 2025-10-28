class Public::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  before_action :deny_deactivated_user
  
  def create
    @post = Post.find(params[:post_id]) # インスタンス変数で宣言するのはjQueryでの部分テンプレート呼出時に必要なため
    like = current_user.likes.new(post_id: @post.id)
    like.save
    respond_to do |format|
      if params[:from_page] == 'posts_show'
        format.js { render :create_at_posts_show }
      else
        format.js { render :create }
      end
    end
  end

  def destroy
    @post = Post.find(params[:post_id]) # インスタンス変数で宣言するのはjQueryでの部分テンプレート呼出時に必要なため
    like = current_user.likes.find_by(post_id: @post.id)
    like.destroy
    respond_to do |format|
      if params[:from_page] == 'posts_show'
        format.js { render :destroy_at_posts_show }
      else
        format.js { render :destroy }
      end
    end
  end

  private
  def from_posts_show?
    # posts#showでの操作時のみTrueを返す。URLがposts/idかposts/id?=queryの時のみTrueになる
    # 実装変更のため未使用
    request.referer&.match?(/\/posts\/\d+(\?.*)?$/)
  end

  def ensure_guest_user
    if current_user.guest_user?
      redirect_to posts_path, notice: 'ゲストユーザーはいいね機能を使用できません。'
    end
  end
end
