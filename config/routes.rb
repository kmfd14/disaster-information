Rails.application.routes.draw do
  devise_for :users

  root "welcome#index"

  resources :posts do
    resources :comments, except: :show
  end

  resources :categories, except: :show

  resource :profile, only: [:index], path: ''
  get '/profile', to: 'profile#index'

  get '/:short_url', to: 'posts#show', as: 'short_post'

end