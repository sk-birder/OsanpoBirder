class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user
  
  def index
  end
end
