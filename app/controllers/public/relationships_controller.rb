class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  before_action :deny_deactivated_user
  before_action :set_user

  def create
    if @user.id != current_user.id && @user.is_active # 自分自身と、退会済ユーザーはフォローできない
      # current_user.followers.newで「follower_user_idカラムにcurrent_user.idが入ったデータ」を作成する
      new_relationship = current_user.followers.new(followed_user_id: params[:user_id])
      new_relationship.save
    end
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
    destroy_relationship = current_user.followers.find_by(followed_user_id: @user.id)
    # destroy_relationshipがnilでないときのみdestroyを実行 別の画面でフォローを解除していた場合と、対象ユーザーが退会していた時のNoMethodErrorエラー回避
    if destroy_relationship
      destroy_relationship.destroy
    end
    respond_to do |format|
      if params[:from_page] == 'users_show'
        format.js { render :destroy_at_users_show }
      else
        format.js { render :destroy }
      end
    end
  end

  private
  def set_user
    @user = User.find(params[:user_id]) # インスタンス変数で宣言するのはjQueryでの部分テンプレート呼出時に必要なため
  end

  def ensure_guest_user
    if current_user.guest_user?
      redirect_to posts_path, notice: 'ゲストユーザーはフォロー機能を使用できません。'
    end
  end
end
