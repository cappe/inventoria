Rails.application.routes.draw do
  namespace :api, constraints: lambda { |req| req.format == :json } do
    scope module: :v1, path: :v1 do
      get '/auth', to: 'sessions#show'
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'

      resources :inventories, only: [:show] do
        get 'event_logs', to: 'audits#inventory_event_logs'

        post 'place_product', to: 'place_product', as: :place_product_to_inventory
        patch 'use_product', to: 'use_product', as: :use_product_from_inventory

        get 'articles_with_products', to: 'articles#with_products'
        get 'allow_product_usage/:datamatrix', to: 'products#allow_product_usage'
      end

      resources :articles, only: [:index, :create, :update, :destroy]

      get 'article_by_gtin/:gtin', to: 'articles#show'

      namespace :admin do
        resources :inventories, only: [:index, :show, :create, :update, :destroy] do
          resources :users, only: [:index, :create, :update, :destroy]
          resources :inventory_articles, only: [:index, :create, :update, :destroy]
        end
      end

      namespace :superadmin do
        resources :users, only: [:index, :create]
      end
    end
  end
end
