Rails.application.routes.draw do
  mount B1Admin::Engine => "/admin"

  scope "(:locale)", :locale => /ru|uk|en/ do


    %W{add contacts products cities logout payment_success}.each do |item|
      get item, to: "home##{item}"
    end
    %w{search review order feedback add_baner}.each do |item|
      post item, to: "home##{item}"
    end

    root to: "home#main"
    post "/", to: "home#main"
    post "/previev", to: "home#previev"

    get 'page/:page', to: "home#index"

    get "blog", to: "blog#index"
    get "blog/*seo_name", to: "blog#item"
    get "blog/:seo_name.html", to: "blog#item"
    get "blog/category/*seo_name", to: "blog#category"

    get "*path/advert/(:id).:format", to: "home#item", is_new: true
    get "*path/(:id).:format", to: "home#item"



    get "category/*seo_name", to: "home#category"
    post "check/transaction", to: "home#check_transaction"
    post "create/order", to: "users#create_order"

    get "tag/:seo_name", to:"home#city"
    get "product/:id", to:"home#product"

    match "payment", to: "home#payment", via: [:get,:post]



    # match "/404" => "home#error404", via: [ :get, :post, :patch, :delete ]

    resources :users do
      resources :baners ,only: [:update, :create, :edit, :new]
      collection do
        get "signin"
        post "login"
        get "forgot"
        get "registration"
        post "restore"
      end
      member do

        post "create_message"
        post "create_transaction"
        get "messages/:reciver_id", to: "users#messages", as: "user_messages"
      end
    end
  end
end

