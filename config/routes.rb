Rails.application.routes.draw do
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

  match "/404" => "home#error404", via: [ :get, :post, :patch, :delete ]
end

