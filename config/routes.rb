Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "welcome#index"

  get '/posts', to: 'posts#index', as: 'posts'
  get '/categories', to: 'categories#index', as: 'categories'
  get '/:short_url', to: 'posts#show', as: 'short_post'

  resources :posts do
    resources :comments, except: :show
  end
  
  resources :categories, except: :show

end