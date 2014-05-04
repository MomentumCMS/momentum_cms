Rails.application.routes.draw do
  namespace :momentum_cms, path: '/' do
    namespace :admin do
      root to: 'dashboards#index'
      resources :sites
      resources :templates
      resources :files
      resources :pages do
        resources :contents
      end
    end
    
    get '*id', to: 'contents#show'
    root to: 'contents#show'
  end
end
