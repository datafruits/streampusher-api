require 'sidekiq/web'

Rails.application.routes.draw do
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

  resources :radios, only: [:index, :update] do
    member do
      get 'next'
      post 'queue_current_show'
    end
  end

  resources :playlists, only: [:show, :index, :create, :update, :destroy]

  resources :djs

  devise_for :users, skip: 'registrations', controllers: {
    sessions: "sessions",
    omniauth_callbacks: "users/omniauth_callbacks",
    passwords: "passwords"
  }

  resources :anniversary_slots do
    collection do
      post "sign_up"
    end
  end

  as :user do
    get "/login" => "sessions#new"
    post "/login" => "sessions#create"
    delete "/logout" => "sessions#destroy"
    get 'users/edit' => 'registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'registrations#update', :as => 'user_registration'
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
  post '/skip_track' => "skip_track#create"

  resources :host_applications, only: [:create, :index] do
    resources :approvals, only: [:create]
  end

  resources :current_user, only: [:index, :update]
  get "/users/current_user" => "current_user#index"
  put "/users/current_user" => "current_user#update"
  patch "/users/current_user" => "current_user#update"
  resources :profile, only: [:index, :create]

  resources :blog_posts, only: [:index, :create, :show, :update]
  resources :blog_post_bodies, only: [:create, :update]
  resources :blog_post_images, only: [:create]
  resources :liquidsoap_requests, only: [:index]

  resources :chat_bans, only: [:index, :create] do
    delete :index, on: :collection, action: :destroy
  end

  # meant only for consumption by datafruits frontend app
  namespace :api do
    resources :posts, only: [:create]
    resources :forum_threads, only: [:index, :show, :create]
    resources :fruit_summons, only: [:create]

    resources :archives, only: [:index]
    resources :blog_posts, only: [:show, :index]
    resources :tracks, only: [:show, :index]
    resources :djs, id: /[A-Za-z0-9_\.]+?/, only: [:show, :index] do
      resources :tracks, only: [:index], controller: 'djs/tracks'
    end
    resources :listeners, only: [:create] do
      collection do
        get 'validate_email'
        get 'validate_username'
      end
    end
    resources :microtexts, only: [:create, :index]
    resources :schedule, only: [:index]
    resources :wiki_pages, only: [:create, :destroy, :show, :index, :update]
    resources :scheduled_shows, only: [:show, :index]
    resources :track_favorites, only: [:create, :destroy]
  end

  post "/setup" => "setup#create"
  get "/setup/allowed" => "setup#allowed"

  get '/performance_tests', to: 'performance_tests#index'

  root 'landing#index'
end
