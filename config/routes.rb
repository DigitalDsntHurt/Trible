Rails.application.routes.draw do
  resources :mashups
  resources :trump_tweets
  resources :bible_verses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
