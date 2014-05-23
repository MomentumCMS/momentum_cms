Rails.application.routes.draw do
  if MomentumCms.configuration.admin_panel_style == :html5
    namespace :momentum_cms, as: :cms, path: MomentumCms.configuration.admin_panel_mount_point do
      namespace :admin, as: :admin, except: :show, path: '' do
        root to: 'dashboards#selector'
        resources :sites do
          resources :dashboards, only: [:index]
          resources :templates
          resources :files
          resources :pages do
            get :content_blocks, on: :collection
            resources :contents
          end
          resources :snippets
          resources :menus
        end
        get 'sites/:id', to: 'dashboards#selector'
      end
    end
  end

  namespace :momentum_cms, as: :cms, path: MomentumCms.configuration.mount_point do
    get 'momentum_cms/css/:id', to: 'contents#css', format: 'css'
    get 'momentum_cms/js/:id', to: 'contents#js', format: 'js'
    get '*id', to: 'contents#show'
    root to: 'contents#show'
  end

  namespace :momentum_cms, as: :cms_api, path: MomentumCms.configuration.api_mount_point do
    get '*id', to: 'api/contents#show'
  end

end