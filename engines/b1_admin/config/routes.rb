B1Admin::Engine.routes.draw do
	root to: "admin#index"
  get "logout",  to: "sessions#destroy"
  get "login",   to: "sessions#new"
  post "login",  to: "sessions#create"
  post "restore",to: "sessions#restore"

  get "profile", to: "user#profile"
  get "messages",to: "user#messages"

  namespace :settings do
  	resources :modules
  	resources :roles
  	resources :permissions
  	resources :admins
    resources :emails
    resources :addresses
    namespace :modules do
      post :update_positions
    end
    namespace :permissions do
      post :actions
    end
    namespace :admins do
      post :upload
      post :history
    end
  end

  namespace :school do
    resources :lessons
    resources :users
    resources :lessons
  	resources :courses do
      post "upload", on: :member
    end
  end
  namespace :club do
    resources :users
    resources :lessons
    resources :courses do
      post "upload", on: :member
    end
  end
  namespace :blog do
    resources :users
    resources :pages do
      post "upload", on: :member
    end
    resources :uploads
    resources :pages
    resources :categories do
      post "update_positions", on: :collection
    end
  end
  namespace :content do
    resources :vacancies
    resources :uploads
    resources :photos do
      post "upload", on: :member
    end
    resources :cvs do
      post "upload", on: :member
    end
    resources :partners do
      post "upload", on: :member
    end
    resources :teachers do
      post "upload", on: :member
    end
  end





end
