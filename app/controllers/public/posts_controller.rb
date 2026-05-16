class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:new]
  before_action :deny_deactivated_user
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def new
    @post = Post.new
    @has_latlng_already = false
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.is_forbidden = false # 本番環境でのエラー回避用
    if @post.save
      @post.is_public ? flash[:notice] = '投稿に成功しました。' : flash[:notice] = '下書きを保存しました。'
      redirect_to post_path(@post.id)
    else
      flash.now[:notice] = '投稿に失敗しました。'
      # マーカーを既に作成していた場合に、マーカーを維持するための分岐
      if post_params[:latitude].present? && post_params[:longitude].present?
        @has_latlng_already = true
      else
        @has_latlng_already = false
      end
      render :new
    end
  end

  def index
    @posts = Post.includes(:category)
                 .visible
                 .sorted_by_published(params[:sort])
                 .page(params[:page])
    @list_type = :published
  end

  def timeline
    return redirect_to(posts_path) if current_user.guest_user?
    @posts = Post.includes(:category)
                 .where(user_id: current_user.following_users.select(:id))
                 .or(Post.where(user_id: current_user.id))
                 .visible
                 .published_recent
                 .page(params[:page])
  end

  def show
    # ログイン中のユーザーの報告の有無と報告内容の確認
    if @post.reported_by?(current_user)
      @current_user_report_detail = current_user.reports.find_by(post_id: @post.id).detail
    end
    # コメント関連
    @post_comment = PostComment.new
    @comments = PostComment.where(post_id: params[:id]).recent
  end

  def edit
    is_matching_login_user
  end

  def update
    is_matching_login_user
    if @post.update(post_params)
      flash[:notice] = '編集に成功しました。'
      redirect_to post_path(@post.id)
    else
      flash.now[:notice] = '編集に失敗しました。'
      render :edit
    end
  end

  def destroy
    is_matching_login_user
    @post.destroy
    redirect_to mypage_path
  end

  def draft
    @drafts = current_user.posts.includes(:category)
                                .user_draft
                                .recent
                                .page(params[:page])
  end

  def forbidden
    @forbidden_posts = current_user.posts.includes(:category)
                                         .admin_forbidden
                                         .recently_updated
                                         .page(params[:page])
  end

  private
  def post_params
    params.require(:post).permit(:latitude, :longitude, :title, :category_id, :prefecture, :month, :body, :is_public, post_images: [])
  end

  def ensure_guest_user
    if current_user.guest_user?
      redirect_to posts_path, notice: 'ゲストユーザーは新規投稿画面へ遷移できません。'
    end
  end

  def set_post
    @post = Post.find_by(id: params[:id]) # findではエラーになるが、find_byを使うと投稿が存在しない時にnilが戻り値になる
    if @post.blank?
      flash[:alert] = '指定された投稿は存在しないか、削除されています。'
      redirect_to timeline_path
    end
  end

  def is_matching_login_user
    # @postはset_postで定義済み
    if @post.user_id != current_user.id
      redirect_to timeline_path
    end
  end
end
