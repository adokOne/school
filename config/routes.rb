Rails.application.routes.draw do
  mount Tolk::Engine => '/tolk', :as => 'tolk'
  mount B1Admin::Engine => "/admin"
  root to: "home#index"

  %w{partners club contacts school}.each do |meth|
    get meth, to: "home##{meth}"
  end
  get "blog", to: "blog#index"
  get "blog/category/*seo_name", to: "blog#category"
  get "blog/item/*seo_name", to: "blog#item"
  get "blog/search", to: "blog#search"
  post "blog/subscribe", to: "blog#subscribe"
  post "send_cv", to: "home#add_cv"
  post "subscribe", to: "home#subscribe"
  post "call", to: "home#call"
  get "show_vacancy", to: "home#show_vacancy"
  get "refresh_fb_reviews", to: "home#refresh_fb_reviews"

  match "/404" => "home#error404", via: [ :get, :post, :patch, :delete ]


  namespace :test do
    resources 'surveys'
    resources 'attempts'
    resources 'users', only: [:create]

    delete 'attempts/:survey_id/:user_id' => 'attempts#delete_user_attempts', as: :delete_user_attempts
    post 'user/:id/change_name' => 'users#change_name', as: :change_user_name
  end

end

