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
  get 'mypage' => 'public/users#mypage'
  # この下2つは退会関連 resourcesより上に書かないとshowが優先されてRouting errorになる
  get   'users/deactivate' => 'public/users#confirm',    as: 'user_confirm'
  patch 'users/deactivate' => 'public/users#deactivate', as: 'user_deactivate'
  resources :users, only: [:index, :show, :edit, :update], controller: 'public/users' do
    resource :relationships, only: [:create, :destroy], controller: 'public/relationships'
  end
  get 'users/:id/following' => 'public/users#following', as: 'user_following'
  get 'users/:id/followers' => 'public/users#followers', as: 'user_followers'
  get 'users/:id/likes'     => 'public/users#likes',     as: 'user_likes'
  get 'users/:id/comments'  => 'public/users#comments',  as: 'user_comments'

  # public/posts
  get 'timeline' => 'public/posts#timeline'
  resources :posts, controller: 'public/posts' do
    resource  :like,     only: [:create, :destroy],          controller: 'public/likes'
    resource  :report,   only: [:create, :update, :destroy], controller: 'public/reports'
    resources :comments, only: [:create, :destroy],          controller: 'public/post_comments'
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
    get 'users/:id/posts' => 'users#posts', as: 'user_posts'
    get 'users/:id/comments' => 'users#comments', as: 'user_comments'
    patch 'users/:id/toggle_activity' => 'users#toggle_activity', as: 'users_toggle_activity'
    patch 'users/:id/banish' => 'users#banish', as: 'users_banish'

    # admin/posts
    # Nest: post_comments(destroy), reports(destroy)
    resources :posts, only: [:index, :show, :update, :destroy] do
      resources :post_comments, only: [:destroy]
      resources :reports, only: [:destroy]
    end
    patch 'posts/:id/toggle_publicity' => 'posts#toggle_publicity', as: 'post_toggle_publicity'

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
