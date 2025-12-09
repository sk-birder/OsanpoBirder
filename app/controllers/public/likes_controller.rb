class Public::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  before_action :deny_deactivated_user
  before_action :set_post
  
  def create
    like = current_user.likes.new(post_id: @post.id)
    like.save # NOT NULL制約があるため分岐不要
    respond_to do |format|
      if params[:from_page] == 'posts_show'
        format.js { render :create_at_posts_show }
      else
        format.js { render :create }
      end
    end
  end

  def destroy
    like = current_user.likes.find_by(post_id: @post.id)
    if like
      like.destroy # NoMethodError回避のためlikeが存在するときのみ実行
    end
    respond_to do |format|
      if params[:from_page] == 'posts_show'
        format.js { render :destroy_at_posts_show }
      else
        format.js { render :destroy }
      end
    end
  end

  private
  def ensure_guest_user
    if current_user.guest_user?
      redirect_to posts_path, notice: 'ゲストユーザーはいいね機能を使用できません。'
    end
  end

  def set_post
    @post = Post.find_by(id: params[:post_id]) # インスタンス変数で宣言するのはjQueryでの部分テンプレート呼出時に必要なため
    if @post.blank?
      flash[:alert] = '対象の投稿が削除されています。'
      redirect_back fallback_location: timeline_path
    end
  end

  def from_posts_show?
    # posts#showでの操作時のみTrueを返す。URLがposts/idかposts/id?=queryの時のみTrueになる
    # 実装変更のため未使用
    request.referer&.match?(/\/posts\/\d+(\?.*)?$/)
  end
end
