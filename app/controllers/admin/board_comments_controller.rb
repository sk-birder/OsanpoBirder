class Admin::BoardCommentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :deny_deactivated_admin

end
