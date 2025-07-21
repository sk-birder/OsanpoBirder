class Admin::ReportsController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

  def index
  end
end
