module PublicRoutes
  def self.extended(router)
    router.instance_eval do
      namespace 'api', module: 'api/public' do
        namespace :v1 do
          get :test, to: 'test#test'

          resources :skus
          resources :batches
          resources :locations
          resources :vendors
          resources :inventories
        end
      end
    end
  end
end
