Rails.application.routes.draw do
  resources :votes
  devise_for :users
  resources :restaurants, except: [:destroy] 
  root 'restaurants#index', as: 'restaurants_index'

  get '/restaurants/page/:page', to: 'restaurants#go_to_page', as: 'restaurants_page'
  get '*path' => redirect('/')

  put '/restaurants/:id/upvote', to: 'restaurants#upvote', as: 'upvote'
  put '/restaurants/:id/downvote', to: 'restaurants#downvote', as: 'downvote'
end
