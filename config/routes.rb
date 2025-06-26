Rails.application.routes.draw do
  devise_for :users
  root to: 'public/homes#top'
  get 'about' => 'public/homes#about'
end
