Rails.application.routes.draw do
  resources :comments
  devise_for :users
  get '/users/profile', to: 'users#show', as: 'user_profile'
  resources :restaurants, except: [:destroy] do
    member do
      put 'upvote', as: 'upvote'
      put 'downvote', as: 'downvote'
      put 'favorite', as: 'favorite'
    end
  end
  root 'restaurants#index', as: 'restaurants_index'

  get '/restaurants/page/:page', to: 'restaurants#go_to_page', as: 'restaurants_page'
  get '*path' => redirect('/')

end
