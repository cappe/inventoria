Rails.application.routes.draw do
  namespace :api, constraints: lambda { |req| req.format == :json } do
    scope module: :v1, path: :v1 do
      get '/auth', to: 'sessions#show'
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'

      scope module: :inventories, path: 'inventories' do
        post 'place_product', to: 'place_product', as: :place_product_to_inventory
      end
    end
  end
end
