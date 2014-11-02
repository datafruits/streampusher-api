Rails.application.routes.draw do
  resources :radios

  resources :playlists

  resources :subscriptions

  resources :djs

  devise_for :users, controllers: { registrations: 'registrations' }

  #root 'home#index'
  root 'landing#index'
end
