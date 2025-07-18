class Public::SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user

  def search
    @model = params[:model]   # 検索対象
    @text = params[:text]     # 検索テキスト
    @method = params[:method] # 検索方式
    if @model == 'user'
      @records = User.search_for(@text, @method)
    else
      @records = Post.search_for(@text, @method)
    end
  end
end
