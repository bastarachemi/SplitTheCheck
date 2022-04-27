Rails.application.routes.draw do
  get 'users/show'
  devise_for :users
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
