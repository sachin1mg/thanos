module PublicRoutes
  def self.extended(router)
    router.instance_eval do
      namespace 'api', module: 'api/public' do
        namespace :v1 do
          resources :sales_orders, only: [:index, :show]
        end
      end
    end
  end
end
