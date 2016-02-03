Rails.application.routes.draw do
  mount Tolk::Engine => '/tolk', :as => 'tolk'
  mount B1Admin::Engine => "/akvarium"

  scope "(:locale)", :locale => /ru|uk|en/ do

    constraints DomainConstraint.new('uex.click') do
      root to: 'click#index', as: "click_root"
      get "price.html", to: "click#prices"
      get "portfolio.html", to: "click#portfolio"
      get "about.html", to: "click#about"
      get "kontekst-reklama.html", to: "click#kontekst"
      get "marketing.html", to: "click#marketing"
      get "create-site.html", to: "click#create_site"
      get "seo.html", to: "click#seo"
      get "about.html", to: "click#about"
    end

    %W{add contacts products cities logout payment_success}.each do |item|
      get item, to: "home##{item}"
    end
    %w{search review order feedback add_baner}.each do |item|
      post item, to: "home##{item}"
    end

    root to: "home#main"
    post "/", to: "home#main"
    post "/previev", to: "home#previev"
    post "/previev_blog", to: "blog#previev_blog"

    get 'page/:page', to: "home#index"

    get "blog", to: "blog#index"
    get "blog/*seo_name", to: "blog#item"
    get "blog/:seo_name.:format", to: "blog#item"
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

        get "forgot"
        get "registration"
        post "restore"
        post "do_login"
      end
      member do

        post "create_message"
        post "create_transaction"
        get "messages/:reciver_id", to: "users#messages", as: "user_messages"
      end
    end
  end
end

