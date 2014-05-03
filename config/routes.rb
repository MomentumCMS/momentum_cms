Rails.application.routes.draw do

  namespace :momentum_cms, path: '/' do
    namespace :admin do
      root to: 'dashboards#index'

      resources :sites
      resources :files

    end

    get '*id', to: 'contents#show'
    root to: 'contents#show'

  end
end
