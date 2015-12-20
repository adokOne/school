Rails.application.routes.draw do
  mount B1Admin::Engine => "/admin"
  root to: "home#main"
  post "/", to: "home#main"
  get "contacts", to: "home#contacts"
  get "products", to: "home#products"
  get 'page/:page', to: "home#index"
  post 'feedback', to: "home#feedback"
  get "blog/*seo_name", to: "blog#item"
  get "cities", to: "home#cities"
  get "blog", to: "blog#index"

  get "blog/category/*seo_name", to: "blog#category"
  get "*path/(:id).:format", to: "home#item"
  get "category/*seo_name", to: "home#category"

  post "check/transaction", to: "home#check_transaction"
  post "create/order", to: "users#create_order"

  get "tag/:seo_name", to:"home#city"

  post "search", to: "home#search"



  # match "/404" => "home#error404", via: [ :get, :post, :patch, :delete ]

  resources :users do
    resources :baners ,only: [:update, :create, :edit, :new]
    collection do
      get "signin"
      post "login"
      get "forgot"
      get "registration"
    end
    member do
      post "create_message"
      post "create_transaction"
      get "messages/:reciver_id", to: "users#messages", as: "user_messages"
    end
  end
end

