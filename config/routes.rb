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
  # Nest: follows, likes(index), post_comments(index)
  resources :users, only: [:index, :show, :edit, :update], controller: 'public/users' do
    resource :follows, only: [:create, :destroy], controller: 'public/follows'
    get 'following' => 'public/follows#following'
    get 'follower' => 'public/follows#follower'
    get 'likes' => 'public/likes#index'
    get 'comments' => 'public/post_comments#index'
    get 'deactivate' => 'public/users#confirm'
    patch 'deactivate' => 'public/users#deactivate'
  end
  get 'mypage' => 'public/users#mypage'

  # public/posts
  # Nest: likes(create, destroy), reports, post_comments(create, destroy)
  resources :posts, controller: 'public/posts' do
    resource :likes, only: [:create, :destroy], controller: 'public/likes'
    resource :reports, only: [:create, :destroy], controller: 'public/reports'
    resources :comments, only: [:create, :destroy], controller: 'public/post_comments'
  end

  # public/searches
  get 'search' => 'public/searches#search'

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
    # admin/homes admin空間のルートディレクトリの設定を兼ねる
    root to: 'homes#top'

    # admin/users
    # 除名関連のRoutingが未実装
    resources :users, only: [:index, :show, :update, :edit]

    # admin/posts
    # Nest: comments(create, destroy), reports(destroy)
    resources :posts, only: [:index, :show, :update, :destroy] do
      resources :comments, only: [:create, :destroy]
      resources :reports, only: [:destroy]
    end

    # admin/reports
    get 'reports' => 'reports#index'

    # admin/boards
    resources :boards, only: [:new, :create, :index, :show, :destroy] do
      resources :board_comments, only: [:create, :destroy]
    end
  end

  # admin/admins
  # URLがadmin/adminsだと煩わしいためnamespace :adminに含めない
  # 他のadmin/xxxが正常に機能しなくなるため最後に記述
  get 'admins_list' => 'admin/admins#index'
  resources :admin, only: [:show, :update, :edit], controller: 'admin/admins' do
    get 'deactivate' => 'admin/admins#confirm'
    patch 'deactivate' => 'admin/admins#deactivate'
  end
end
