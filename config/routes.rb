Rails.application.routes.draw do
  # エンドユーザ側
  scope module: :public do
    devise_for :users
    root to: 'homes#top'
    get 'about' => 'homes#about'
  end

  # 管理者側
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
