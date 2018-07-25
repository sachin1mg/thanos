Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/health',     to: 'application#health'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace 'api', module: 'api/public' do
    namespace :v1 do
    end
  end
end
