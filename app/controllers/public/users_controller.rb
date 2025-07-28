class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user

  def index
  end

  def mypage
    @profile = User.find(current_user.id) # 不要かも
    @posts = Post.where("user_id = ?", current_user.id)
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
    @posts = Post.where('user_id = ?', params[:id])
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

  def confirm
    is_matching_login_user_deactivate
  end

  def deactivate
    is_matching_login_user_deactivate
    @user.update(is_active: false)
    sign_out(current_user)
    flash[:notice] = '退会処理が完了しました。'
    redirect_to root_path
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

  def is_matching_login_user_deactivate
    @user = User.find(params[:user_id])
    # ゲストユーザーか確認
    if @user.guest_user?
      redirect_to posts_path, notice: 'ゲストユーザーは退会画面へ遷移できません。'
    end
    # ログインIDの一致を確認
    if @user.id != current_user.id
      redirect_to mypage_path
    end
  end

  # 未使用のメソッド 不要ならば消去
  def safe_user
    @user = User.find(params[:id])
    @safe_user = @user.attributes.except('email')
  end
end
