class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user

  def create
    # current_user.followers.newで「follower_user_idカラムにcurrent_user.idが入ったデータ」を作成する
    new_relationship = current_user.followers.new(followed_user_id: params[:user_id])
    new_relationship.save
    redirect_back fallback_location: root_path
  end

  def destroy
    # current_user.followers.find_byで「follower_user_idカラムにcurrent_user.idが入ったデータ」にfind_byを実行する
    destroy_relationship = current_user.followers.find_by(followed_user_id: params[:user_id])
    destroy_relationship.destroy
    redirect_back fallback_location: root_path
  end
end
