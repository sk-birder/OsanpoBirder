Rails.application.routes.draw do
  # エンドユーザ側
  scope module: :public do
    devise_for :users
    root to: 'homes#top'
    get 'about' => 'homes#about'
  end

  # 管理者側
  devise_for :admin, controllers: {
    registrations: 'admin/registrations',
    sessions: 'admin/sessions'
  }

  # namespace :admin do
  # end
end
