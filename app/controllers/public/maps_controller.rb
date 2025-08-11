class Public::MapsController < ApplicationController
  def index
    @posts = Post.where(is_public: true, is_forbidden: false)
  end

  # def xxx
  #   # 地図関連
  #   respond_to do |format|
  #     # リクエストされるフォーマットがHTML形式の場合
  #     format.html do
  #       @xxx = Model.xxx
  #     end
  #     # リクエストされるフォーマットがJSON形式の場合
  #     format.json do
  #       @xxx = Model.xxx
  #     end
  #   end
  # end
end
