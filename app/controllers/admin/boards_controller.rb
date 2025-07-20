class Admin::BoardsController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

  def new
  end

  def index
  end

  def show
  end
end
