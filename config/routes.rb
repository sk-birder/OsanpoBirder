Rails.application.routes.draw do
  # --- エンドユーザ側 ---
  # devise
  scope module: :public do
    devise_for :users
  end
  # devise ゲストログイン用
  devise_scope :user do
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  # public/homes ルートディレクトリの設定を兼ねる
  root to: 'public/homes#top'
  get 'about' => 'public/homes#about'

  # public/users
  # Nest: relationships, likes(index), post_comments(index)
  resources :users, only: [:index, :show, :edit, :update], controller: 'public/users' do
    # get 'following' => 'public/follows#following'
    # get 'follower' => 'public/follows#follower'
    resource :relationship, only: [:create, :destroy], controller: 'public/relationships'
    get 'likes' => 'public/likes#index'
    get 'comments' => 'public/post_comments#index'
    get 'deactivate' => 'public/users#confirm'
    patch 'deactivate' => 'public/users#deactivate'
  end
  get 'mypage' => 'public/users#mypage'

  # public/posts
  # Nest: likes(create, destroy), reports, post_comments(create, destroy)
  resources :posts, controller: 'public/posts' do
    resource :like, only: [:create, :destroy], controller: 'public/likes'
    resource :report, only: [:create, :update, :destroy], controller: 'public/reports'
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
    resources :users, only: [:index, :show, :update, :edit]
    patch 'users/:id/toggle_activity' => 'users#toggle_activity', as: 'users_toggle_activity'
    patch 'users/:id/banish' => 'users#banish', as: 'users_banish'

    # admin/posts
    # Nest: post_comments(destroy), reports(destroy)
    resources :posts, only: [:index, :show, :update, :destroy] do
      resources :post_comments, only: [:destroy]
      resources :reports, only: [:destroy]
    end

    # admin/post_comments(index)
    get 'post_comments' => 'post_comments#index'

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
