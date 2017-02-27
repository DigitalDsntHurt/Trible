Rails.application.routes.draw do
  get 'landing/index'
  root 'landing#index'

  resources :mashups
  put 'set_tweet_to_true' => 'mashups#set_tweet_to_true'
  
  put 'generate_new_mashups' => 'mashups#generate_new_mashups'
  post 'clear_unqueued_mashups' => 'mashups#clear_unqueued_mashups'
  post 'clear_all_mashups' => 'mashups#clear_all_mashups'

  resources :trump_tweets
  resources :bible_verses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
