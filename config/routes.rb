Rails.application.routes.draw do
  # --- エンドユーザ側 ---
  # devise
  scope module: :public do
    devise_for :users
  end

  # public/homes ルートディレクトリの設定を兼ねる
  root to: 'public/homes#top'
  get 'about' => 'public/homes#about'

  # public/users
  # Nest: follows, likes(index), comments(index)
  resources :users, only: [:index, :show, :edit, :update], controller: 'public/users' do
    resource :follows, only: [:create, :destroy], controller: 'public/follows'
    get 'following' => 'public/follows#following'
    get 'follower' => 'public/follows#follower'
    get 'likes' => 'public/likes#index'
    get 'comments' => 'public/comments#index'
    get 'deactivate' => 'public/users#confirm'
    patch 'deactivate' => 'public/users#deactivate'
  end
  get 'mypage' => 'public/users#mypage'

  # public/posts
  # Nest: likes(create, destroy), reports, comments(create, destroy)
  resources :posts, controller: 'public/posts' do
    resource :likes, only: [:create, :destroy], controller: 'public/likes'
    resource :reports, only: [:create, :destroy], controller: 'public/reports'
    resources :comments, only: [:create, :destroy], controller: 'public/comments'
  end

  # --- 管理者側 ---
  # 副管理者機能を実装する際に使用
  # devise_for :admin, controllers: {
  #   registrations: 'admin/registrations',
  #   sessions: 'admin/sessions'
  # }
  devise_for :admin, skip: [:password, :registrations], controllers: {
    sessions: 'admin/sessions'
  }
  namespace :admin do
     root to: 'homes#top'
  end
end
