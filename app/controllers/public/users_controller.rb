class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user

  def index
    @users = User.active.except_guest # ページネータを追加すること
  end

  def mypage
    posts = current_user.posts

    drafts = posts.user_draft
    @drafts = drafts.recent.limit(3)
    @drafts_count = drafts.count

    forbidden_posts = posts.admin_forbidden
    @forbidden_posts = forbidden_posts.recently_updated.limit(3)
    @forbidden_posts_count = forbidden_posts.count
  end

  def edit
    is_matching_login_user
  end

  def update
    is_matching_login_user
    if @user.update(user_params)
      flash[:notice] = '編集に成功しました。'
      redirect_to mypage_path
    else
      flash.now[:notice] = '編集に失敗しました。'
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(user_id: params[:id])
                 .visible
                 .sorted_by_published(params[:posts_sort])
                 .page(params[:page])
  end

  def following
    @user = User.find(params[:id])
    @following = @user.ordered_following_users(params[:sort])
                      .page(params[:page])
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.ordered_follower_users(params[:sort])
                      .page(params[:page])
  end

  def likes
    @user = User.find(params[:id])
    @liked_posts = @user.ordered_liked_posts(params[:sort])
                        .page(params[:page])
  end

  def comments
    @user = User.find(params[:id])
  end

  def confirm
    if current_user.guest_user?
      redirect_to posts_path, notice: 'ゲストユーザーは退会画面へ遷移できません。'
    end
  end

  def deactivate
    if current_user.guest_user?
      redirect_to posts_path, notice: 'ゲストユーザーは退会できません。'
    else
      user = User.find(current_user.id)
      user.update(is_active: false)
      # フォロー・いいね・報告の削除(強制)
      Relationship.where(followed_user_id: user.id).or(Relationship.where(follower_user_id: user.id)).destroy_all
      user.likes.destroy_all
      user.reports.destroy_all
      # 投稿・コメントの削除(任意)
      if params[:delete_posts].to_i == 1
        user.posts.destroy_all
        user.post_comments.destroy_all
      end
      sign_out(current_user)
      redirect_to root_path, notice: '退会処理が完了しました。'
    end
  end

  private
  def user_params
    params.require(:user).permit(:profile_image, :email, :name, :prefecture, :hide_prefecture, :birth_year, :hide_birth_year, :introduction)
  end

  def is_matching_login_user
    @user = User.find(params[:id])
    # ゲストユーザーか確認
    if @user.guest_user?
      redirect_to posts_path, notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
    # ログインIDの一致を確認
    if @user.id != current_user.id
      redirect_to mypage_path
    end
  end
end
