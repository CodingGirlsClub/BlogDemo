Rails.application.routes.draw do
  get 'comments/index'

  get 'comments/new'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'visitors#index'
  resources :articles do
    resources :comments, only: [:index, :new, :create]
  end
end
