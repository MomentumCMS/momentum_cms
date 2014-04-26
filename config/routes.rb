Rails.application.routes.draw do
  get '*id', to: 'momentum_cms/variations#show'
  root to: 'momentum_cms/variations#show'
end
