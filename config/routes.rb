Rails.application.routes.draw do
  resources :recordings
  resources :podcasts, only: [:index, :show]

  resources :shows
  resources :scheduled_shows
  get "/schedule", to: "scheduled_shows#index", as: :schedule

  resources :stats, only: [:index]
  resources :listens, only: [:index]

  resources :radios

  resources :playlists do
    member do
      post 'add_track'
      post 'remove_track'
      post 'update_order'
    end
  end

  resources :subscriptions

  resources :djs

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }

  as :user do
    get "/login" => "sessions#new"
    post "/login" => "sessions#create"
    delete "/logout" => "sessions#destroy"
  end

  get 'admin', to: 'admin#index', as: 'admin'
  get 'admin/:id/radios', to: 'admin#radios', as: 'admin_radios'
  post 'admin/radios/:id/restart', to: 'admin#restart_radio', as: 'admin_restart_radio'

  resources :tracks, only: [:create]

  #root 'home#index'
  root 'landing#index'
end
