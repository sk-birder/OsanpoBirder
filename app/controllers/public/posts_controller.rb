class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_deactivated_user

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.main_class_id = 1 # テスト用のダミーデータ登録
    @post.sub_class_id = 2  # テスト用のダミーデータ登録
    @post.is_forbidden = false # 本番環境でのエラー回避用の応急処置
    if @post.save
      flash[:notice] = '投稿に成功しました。'
      redirect_to post_path(@post.id)
    else
      flash.now[:notice] = '投稿に失敗しました。'
      render :new
    end
  end

  def index
    @posts = Post.where("(is_public = ?) AND (is_forbidden = ?)", true, false)
  end

  def show
    @show_post = Post.find(params[:id])
    @new_user_comment = PostComment.new
    @comments = PostComment.where('post_id = ?', params[:id])
    # 投稿ユーザか判定
    if @show_post.user_id != current_user.id
      # 投稿ユーザではない場合はis_publicとis_forbiddenの内容を確認し、
      # 非公開ならば@show_post = nilとしViewにデータを渡さないようにする
      if @show_post.is_public == false
        @show_post = nil
      end
      if @show_post.is_forbidden == true
        @show_post = nil
      end
    end
  end

  def edit
    is_matching_login_user
  end

  def update
    is_matching_login_user
    if @post.update(post_params)
      flash[:notice] = '編集に成功しました。'
      redirect_to post_path(@post.id)
    else
      flash.now[:notice] = '編集に失敗しました。'
      render :edit
    end
  end

  def destroy
    is_matching_login_user
    @post.destroy
    redirect_to mypage_path
  end

  private
  def post_params
    params.require(:post).permit(:title, :main_class_id, :sub_class_id, :prefecture, :month, :body, :is_public)
  end

  def is_matching_login_user
    @post = Post.find(params[:id])
    if @post.user_id != current_user.id
      redirect_to posts_path
    end
  end
end
