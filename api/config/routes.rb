Rails.application.routes.draw do
  namespace :api, constraints: lambda { |req| req.format == :json } do
    scope module: :v1, path: :v1 do
      get '/auth', to: 'sessions#show'
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
    end
  end
end
