class Public::FollowsController < ApplicationController
  before_action :authenticate_user!
  
  def following
  end

  def followers
  end
end
