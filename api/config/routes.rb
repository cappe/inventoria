Rails.application.routes.draw do
  namespace :api, constraints: lambda { |req| req.format == :json } do
    scope module: :v1, path: :v1 do
      get '/auth', to: 'sessions#show'
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'

      resources :inventories, only: [:show] do
        resources :products, only: [:index]

        get 'event_logs', to: 'audits#inventory_event_logs'

        post 'place_product', to: 'place_product', as: :place_product_to_inventory
        patch 'use_product', to: 'use_product', as: :use_product_from_inventory
      end

      resources :articles, only: [:index, :create, :update, :destroy]

      namespace :admin do
        resources :inventories, only: [:index, :show, :create, :update, :destroy] do
          resources :users, only: [:index, :create, :update, :destroy]

          put 'inventory_articles', to: 'inventory_articles#replace_all'
        end
      end
    end
  end
end
