class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.main_class_id = 1.0 # テスト用のダミーデータ登録
    @post.sub_class_id = 2.0  # テスト用のダミーデータ登録
    if @post.save
      flash[:notice] = '投稿に成功しました。'
      redirect_to post_path(@post.id)
    else
      flash[:notice] = '投稿に失敗しました。'
      render :new
    end
  end

  def index
  end

  def show
    @show_post = Post.find(params[:id])
  end

  def edit
  end

  private
  def post_params
    params.require(:post).permit(:title, :main_class_id, :sub_class_id, :prefecture, :month, :body, :is_public)
  end
end
