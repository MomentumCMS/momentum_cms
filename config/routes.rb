Rails.application.routes.draw do
  namespace :momentum_cms, as: :cms, path: '/' do
    namespace :admin, as: :admin, except: :show do
      root to: 'dashboards#selector'
      resources :sites do
        resources :dashboards, only: [:index]
        resources :templates
        resources :files
        resources :pages do
          resources :contents
        end
      end
      get 'sites/:id', to: 'dashboards#selector'
    end

    get 'momentum_cms/css/:id', to: 'contents#css'
    get 'momentum_cms/js/:id', to: 'contents#js'


    get '*id', to: 'contents#show'
    root to: 'contents#show'
  end
end
