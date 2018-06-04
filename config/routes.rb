Rails.application.routes.draw do
  root to: 'toppages#index'
  post '/', to: 'toppages#create'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  # get 'edit/post', to: 'users#edit'
  
  resources :users, only: [:index, :show, :new, :create, :edit]
  resources :posts
end
