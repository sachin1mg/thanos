module PublicRoutes
  def self.extended(router)
    router.instance_eval do
      namespace 'api', module: 'api/public' do
        namespace :v1 do
          resources :skus do
            resources :batches
          end

          resources :vendors, only: [:create, :update, :index, :show]
          resources :locations, only: [:create, :update, :index, :show]
          resources :inventories

          resources :sales_orders do
            resources :invoices
            resources :sales_order_items
            resources :inventory_pickups
          end
          resources :suppliers, only: [:create, :update, :index, :show] do
            resources :purchase_orders, except: [:new, :edit, :destroy]
          end
          resources :purchase_orders, except: [:new, :edit, :destroy] do
            resources :purchase_order_items, except: [:new, :edit, :destroy]
          end
          resources :material_requests, only: [:index, :show]
          resources :purchase_receipts, except: [:new, :edit, :destroy] do
            collection do
              post 'verify'
              post 'verify_csv'
            end
            resources :purchase_receipt_items, except: [:new, :edit, :destroy]
          end
          resources :schemes, only: [:create, :update, :index, :show]
          resources :vendor_supplier_contracts, only: [:create, :update, :index, :show]
          resources :supplier_skus, only: [:create, :update, :index, :show]
          resources :vendor_supplier_schemes, only: [:create, :update, :index, :show]
          resources :batches, only: [:update, :index, :show]
        end
      end
    end
  end
end
