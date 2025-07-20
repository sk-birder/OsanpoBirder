class Admin::AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

  def index
  end

  def show
  end

  def edit
  end

  def confirm
  end
end
