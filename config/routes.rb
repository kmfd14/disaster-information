Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "welcome#index"

  resources :posts do
    resources :comments, except: :show
  end

  resources :categories, except: :show
  get '/:short_url', to: 'posts#show', as: 'short_post'

end