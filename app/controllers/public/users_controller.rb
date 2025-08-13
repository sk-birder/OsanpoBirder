class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user

  def index
    @users = User.where('is_active = ?', true)
  end

  def mypage
    @posts = Post.where(user_id: current_user.id)
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
    @posts = Post.where(user_id: params[:id], is_public: true, is_forbidden: false)
  end

  def following
    @user = User.find(params[:id])
    # @user.followersで「follower_user_idカラムにparams[:id]が入ったデータ」を取得し、followed_user_idを配列に格納
    following_ids = @user.followers.pluck(:followed_user_id)
    @following = User.where(id: following_ids)
  end

  def followers
    @user = User.find(params[:id])
    # @user.followedsで「followed_user_idカラムにparams[:id]が入ったデータ」を取得し、follower_user_idを配列に格納
    follower_ids = @user.followeds.pluck(:follower_user_id)
    @followers = User.where(id: follower_ids)
  end

  def likes
    @user = User.find(params[:id])
    # いいねした投稿のIDを取得して配列に格納
    liked_post_ids = Like.where(user_id: @user.id).pluck(:post_id)
    # 公開記事の中から該当する投稿のみ取得
    @liked_posts = Post.where(is_public: true, is_forbidden: false).where(id: liked_post_ids)
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
