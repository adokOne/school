Rails.application.routes.draw do
  mount B1Admin::Engine => "/admin"
  root to: "home#main"
  get "contacts", to: "home#contacts"
  get "products", to: "home#products"
  get 'page/:page', to: "home#index"
  post 'feedback', to: "home#feedback"
  get "blog/*seo_name", to: "blog#item"
  get "blog", to: "blog#index"
  get "blog/category/*seo_name", to: "blog#category"
  get "*path/(:id).:format", to: "home#item"
  get "category/*seo_name", to: "home#category"
  # %w{partners club contacts school}.each do |meth|
  #   get meth, to: "home##{meth}"
  # end
  # get "blog", to: "blog#index"
  # get "blog/category/*seo_name", to: "blog#category"
  # get "blog/item/*seo_name", to: "blog#item"
  # get "blog/search", to: "blog#search"
  # post "blog/subscribe", to: "blog#subscribe"
  # post "send_cv", to: "home#add_cv"
  # post "subscribe", to: "home#subscribe"

  # match "/404" => "home#error404", via: [ :get, :post, :patch, :delete ]

  resources :users do
    collection do
      get "signin"
      post "login"
      get "forgot"
      get "registration"
    end
  end
end

