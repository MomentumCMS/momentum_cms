Rails.application.routes.draw do

  if MomentumCms.configuration.api_level == :full
    match '*path' => 'momentum_cms/api/base#respond_to_options_request', constraints: { method: 'OPTIONS' }, via: [:options]
  end

  namespace :momentum_cms, as: :cms, path: MomentumCms.configuration.api_mount_point do
    namespace :api, as: :api, path: '' do
      resources :documents, only: [:index, :show]
      if MomentumCms.configuration.api_level == :full
        resources :sessions, only: [:create, :destroy]
        namespace :admin, as: :admin do
          resources :sites
          resources :pages
          resources :templates
        end
      end
    end
  end

  if MomentumCms.configuration.admin_panel_style == :html5
    namespace :momentum_cms, as: :cms, path: MomentumCms.configuration.admin_panel_mount_point do
      namespace :admin, as: :admin, except: :show, path: '' do
        root to: 'dashboards#selector'
        resources :sites do
          member do
            post :sync_remote
          end
          resources :dashboards, only: [:index]
          resources :templates
          resources :files
          resources :pages do
            member do
              post :publish
              post :unpublish
            end
            collection do
              get :blocks
            end
          end
          resources :snippets
          resources :menus
          resources :blue_prints
          resources :documents do
            member do
              post :publish
              post :unpublish
            end
            collection do
              get :fields
            end
          end
        end
        get 'sites/:id', to: 'dashboards#selector'
      end
    end
  end

  namespace :momentum_cms, as: :cms, path: MomentumCms.configuration.mount_point do
    get 'momentum_cms/css/:id', to: 'pages#css', format: 'css'
    get 'momentum_cms/js/:id', to: 'pages#js', format: 'js'
    get '*id', to: 'pages#show'
    root to: 'pages#show'
  end
end