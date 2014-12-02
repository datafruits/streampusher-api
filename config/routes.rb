Rails.application.routes.draw do
  resources :recordings

  resources :shows

  resources :stats, only: [:index]

  resources :radios

  resources :playlists

  resources :subscriptions

  resources :djs

  devise_for :users, controllers: { registrations: 'registrations' }

  get 'admin', to: 'admin#index'

  resources :tracks, only: [:create]

  #root 'home#index'
  root 'landing#index'
end
