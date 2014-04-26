Rails.application.routes.draw do
  get '*path', to: 'momentum_cms/pages#show', format: false
end
