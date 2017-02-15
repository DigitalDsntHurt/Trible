Rails.application.routes.draw do
  get 'landing/index'
  root 'landing#index'

  resources :mashups
  put 'set_tweet_to_true' => 'mashups#set_tweet_to_true'
  resources :trump_tweets
  resources :bible_verses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
