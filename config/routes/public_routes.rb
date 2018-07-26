module PublicRoutes
  def self.extended(router)
    router.instance_eval do
      namespace 'api', module: 'api/public' do
        namespace :v1 do
          resources :sales_orders
          resources :inventory_pickups
        end
      end
    end
  end
end
