require 'sidekiq/web'

Rails.application.routes.draw do
  mount_ember_assets :frontend, to: "/"
  # mount_ember_app :frontend, to: "/playlists", controller: "playlists", action: "index"
  authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
  end

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

  resources :djs

  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  # devise_scope :user do
  #   resource :registration,
  #     only: [:new, :create, :edit, :update],
  #     path: 'users',
  #     path_names: { new: 'sign_up' },
  #     controller: 'devise/registrations',
  #     as: :user_registration do
	# get :cancel
  #     end
  # end

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

  resources :tracks do
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
  post '/publish_metadata' => "publish_metadata#create"
  post '/live_notification' => "live_notification#create"
  post '/donation_link' => "donation_link#create"

  resources :host_applications, only: [:create, :index] do
    resources :approvals, only: [:create]
  end

  resources :current_user, only: [:index]
  get "/users/current_user" => "current_user#index"
  resources :profile, only: [:index, :create]

  resources :blog_posts, only: [:index, :create, :show, :update]
  resources :blog_post_bodies, only: [:create, :update]
  resources :blog_post_images, only: [:create]

  resources :chat_bans, only: [:index]

  namespace :api do
    resources :blog_posts, only: [:show, :index]
  end
  post "/setup" => "setup#create"
  get "/setup/allowed" => "setup#allowed"

  root 'landing#index'
end
