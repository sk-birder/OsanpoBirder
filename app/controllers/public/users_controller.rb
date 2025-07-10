class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user

  def index
  end

  def mypage
    @profile = User.find(current_user.id) # 不要かも
    @posts = Post.where("user_id == ?", current_user.id)
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
  end

  def confirm
    is_matching_login_user_deactivate
  end

  def deactivate
    is_matching_login_user_deactivate
    @user.update(is_active: false)
    sign_out(current_user)
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:email, :name, :prefecture, :hide_prefecture, :birth_year, :hide_birth_year, :introduction)
  end

  def is_matching_login_user
    @user = User.find(params[:id])
    if @user.id != current_user.id
      redirect_to mypage_path
    end
  end

  def is_matching_login_user_deactivate
    @user = User.find(params[:user_id])
    if @user.id != current_user.id
      redirect_to mypage_path
    end
  end  
end
