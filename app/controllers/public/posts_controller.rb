class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.main_class_id = 1 # テスト用のダミーデータ登録
    @post.sub_class_id = 2  # テスト用のダミーデータ登録
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
    # 投稿ユーザか判定
    if @show_post.user_id != current_user.id
      # 投稿ユーザではない場合はis_publicとis_forbiddenの内容を確認し、
      # 非公開ならばViewにデータを渡さないようにする(@show_post = nil)
      if @show_post.is_public == false
        @show_post = nil
      elsif @show_post.is_forbidden == true
        @show_post = nil
      end
    end
  end

  def edit
  end

  private
  def post_params
    params.require(:post).permit(:title, :main_class_id, :sub_class_id, :prefecture, :month, :body, :is_public)
  end
end
