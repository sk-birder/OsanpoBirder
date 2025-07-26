class Public::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  before_action :deny_deactivated_user
  
  def index
    @user = User.find(params[:user_id])
    # いいねした投稿のIDを取得して配列に格納
    liked_posts_ids = Like.where('user_id = ?', @user.id).pluck(:post_id)
    # 公開記事の中から該当する投稿のみ取得
    @liked_posts = Post.where("(is_public = ?) AND (is_forbidden = ?)", true, false).where(id: liked_posts_ids)
  end

  def create
    post = Post.find(params[:post_id])
    like = current_user.likes.new(post_id: post.id)
    like.save
    redirect_to post_path(post)
  end

  def destroy
    post = Post.find(params[:post_id])
    like = current_user.likes.find_by(post_id: post.id)
    like.destroy
    redirect_to post_path(post)
  end

  private
  def ensure_guest_user
    if current_user.guest_user?
      redirect_to posts_path, notice: 'ゲストユーザーはいいね機能を使用できません。'
    end
  end
end
