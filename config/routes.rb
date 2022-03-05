Rails.application.routes.draw do
  resources :restaurants
  root 'restaurants#index', as: 'restaurants_index'

  get '/restaurants/page/:page', to: 'restaurants#go_to_page', as: 'restaurants_page'
  get '*path' => redirect('/')
end
