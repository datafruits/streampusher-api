require 'sidekiq/web'

Rails.application.routes.draw do
  mount_ember_assets :frontend, to: "/"
  # mount_ember_app :frontend, to: "/playlists", controller: "playlists", action: "index"
  authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
  end

  mount StripeEvent::Engine, at: '/stripe_events'

  resources :recordings, only: [:index, :show] do
    resources :process_recordings, only: [:create]
  end
  resources :podcasts

  resources :scheduled_shows do
    collection do
      get 'next'
    end
  end
  get "/schedule", to: "scheduled_shows#index", as: :schedule

  resources :stats, only: [:index]
  resources :listens, only: [:index]

  resources :radios, only: [:index, :edit, :update] do
    member do
      get 'next'
    end
  end

  resources :playlists, only: [:show, :index, :create, :update, :destroy]

  resources :subscriptions, only: [:edit, :update]

  resources :djs

  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  devise_scope :user do
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: 'users',
      path_names: { new: 'sign_up' },
      controller: 'devise/registrations',
      as: :user_registration do
	get :cancel
      end
  end

  resources :anniversary_slots do
    collection do
      post "sign_up"
    end
  end

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

  resources :tracks, only: [:create, :edit, :update, :destroy, :index] do
    member do
      get :embed
    end
    resources :mixcloud_uploads, only: [:create]
    resources :soundcloud_uploads, only: [:create]
  end
  resources :labels, only: [:create, :index, :show]
  resources :uploader_signature, only: [:index]
  resources :playlist_tracks, only: [:create, :edit, :update, :destroy]

  get '/help' => 'help#index', :id => "help_index"
  get '/broadcasting_help' => 'help#broadcasting', :id => "broadcasting_help"

  resources :embeds, only: [:index] do
    collection do
      get 'player'
    end
  end

  resources :social_identities

  authenticated :user do
    root :to =>  "radios#index", as: :authenticated_root
  end

  get '/next' => 'application#next'

  get "/vj" => "vj#index"
  patch "/vj" => "vj#update"
  get "/vj/enabled" => "vj#enabled"

  resources :anniversary_slots, only: [:create, :index, :destroy]
  post '/metadata' => "metadata#create"

  resources :host_applications, only: [:create, :index] do
    resources :approvals, only: [:create]
  end

  root 'landing#index'
end
