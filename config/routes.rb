Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/health',     to: 'application#health'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  extend InternalRoutes
  extend PublicRoutes
end
