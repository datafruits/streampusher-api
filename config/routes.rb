require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
  end

  mount StripeEvent::Engine, at: '/stripe_events'

  resources :recordings, only: [:index]
  resources :podcasts

  resources :shows
  resources :scheduled_shows
  get "/schedule", to: "scheduled_shows#index", as: :schedule

  resources :stats, only: [:index]
  resources :listens, only: [:index]

  resources :radios do
    member do
      get 'next'
    end
  end

  resources :playlists do
    member do
      post 'add_track'
      post 'remove_track'
      post 'update_order'
    end
  end

  resources :subscriptions, only: [:edit, :update]

  resources :djs

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }

  as :user do
    get "/login" => "sessions#new"
    post "/login" => "sessions#create"
    delete "/logout" => "sessions#destroy"
  end

  get 'admin', to: 'admin#index', as: 'admin'
  get 'admin/:id/sign_in', to: 'admin#sign_in_as', as: 'admin_sign_in_as'
  get 'admin/:id/radios', to: 'admin#radios', as: 'admin_radios'
  post 'admin/radios/:id/restart', to: 'admin#restart_radio', as: 'admin_restart_radio'
  post 'admin/radios/:id/disable', to: 'admin#disable_radio', as: 'admin_disable_radio'

  resources :tracks, only: [:create, :edit, :update, :destroy]
  resources :playlist_tracks, only: [:edit, :update]

  get '/broadcasting_help' => 'help#broadcasting', :id => "broadcasting_help"

  resources :embeds, only: [:index] do
    collection do
      get 'player'
    end
  end

  authenticated :user do
    root :to =>  "radios#index", as: :authenticated_root
  end

  root 'landing#index'
end
