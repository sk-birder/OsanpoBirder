class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  before_action :deny_deactivated_user
  before_action :set_user

  def create
    if @user.id != current_user.id && @user.available? # 自分自身と、退会済ユーザーはフォローできない
      new_relationship = current_user.following_relationships.new(followed_user_id: @user.id)
      new_relationship.save # UNIQUE制約があるため分岐不要
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
    current_user.following_relationships
                .find_by(followed_user_id: @user.id)
                &.destroy
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
