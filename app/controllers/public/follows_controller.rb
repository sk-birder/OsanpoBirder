class Public::FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user
  
  def following
  end

  def followers
  end
end
