class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

  def top
  end
end
