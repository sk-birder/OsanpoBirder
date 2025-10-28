class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  before_action :deny_deactivated_user

  def create
    if current_user.id == params[:user_id].to_i
      flash[:notice] = '自分自身はフォローできません。'
    else
      # current_user.followers.newで「follower_user_idカラムにcurrent_user.idが入ったデータ」を作成する
      new_relationship = current_user.followers.new(followed_user_id: params[:user_id])
      new_relationship.save
      # 重複フォローの防止
      if new_relationship.errors.any?
        flash[:notice] = '既にフォロー中です。'
      end
    end
    @user = User.find(params[:user_id]) # インスタンス変数で宣言するのはjQueryでの部分テンプレート呼出時に必要なため
    respond_to do |format|
      if params[:from_page] == 'users_show'
        format.js { render :create_at_users_show }
      else
        format.js { render :create }
      end
    end
  end

  def destroy
    # current_user.followers.find_byで「follower_user_idカラムにcurrent_user.idが入ったデータ」にfind_byを実行する
    destroy_relationship = current_user.followers.find_by(followed_user_id: params[:user_id])
    destroy_relationship.destroy
    @user = User.find(params[:user_id]) # インスタンス変数で宣言するのはjQueryでの部分テンプレート呼出時に必要なため
    respond_to do |format|
      if params[:from_page] == 'users_show'
        format.js { render :destroy_at_users_show }
      else
        format.js { render :destroy }
      end
    end
  end

  private
  def ensure_guest_user
    if current_user.guest_user?
      redirect_to posts_path, notice: 'ゲストユーザーはフォロー機能を使用できません。'
    end
  end
end
