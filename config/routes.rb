Rails.application.routes.draw do
  resources :radios

  resources :playlists

  resources :subscriptions

  devise_for :users

  #root 'home#index'
  root 'landing#index'
end
