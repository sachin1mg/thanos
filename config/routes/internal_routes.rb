module InternalRoutes
  def self.extended(router)
    router.instance_eval do
      namespace '__onemg-internal__', module: 'api/internal', as: :internal do
        namespace :v1 do
        end
      end
    end
  end
end
