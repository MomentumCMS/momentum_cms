Rails.application.routes.draw do
  get '*id', to: 'momentum_cms/contents#show'
  root to: 'momentum_cms/contents#show'
end
