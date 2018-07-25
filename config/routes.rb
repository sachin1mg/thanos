Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  ##################
  ### SIDEKIQ UI ###
  ##################
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  ##############
  ### DEVICE ###
  ##############
  devise_for :users, path: '', controllers: { sessions: :sessions }, path_names: { sign_in: 'login', sign_out: 'logout' }, only: [:sessions]

  ####################
  ### HEALTH CHECK ###
  ####################
  get '/health',     to: 'application#health'

  extend InternalRoutes
  extend PublicRoutes
end
