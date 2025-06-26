Rails.application.routes.draw do
  root to: 'public/homes#top'
  get 'about' => 'public/homes#about'
end
