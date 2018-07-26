module PublicRoutes
  def self.extended(router)
    router.instance_eval do
      namespace 'api', module: 'api/public' do
        namespace :v1 do
          resources :skus do
            resources :batches
          end

          resources :vendors
          resources :locations
          resources :inventories

          resources :sales_orders do
            resources :invoices
            resources :sales_order_items
            resources :inventory_pickups
            resources :material_requests, except: [:new, :edit]
          end
          resources :suppliers, only: [:create, :update, :index, :show] do
            resources :purchase_orders, except: [:new, :edit]
          end
          resources :purchase_orders, except: [:new, :edit] do
            resources :purchase_order_items, except: [:new, :edit]
          end
          resources :material_requests, except: [:new, :edit] do
            resources :material_request_items, except: [:new, :edit]
          end
          resources :purchase_receipts, except: [:new, :edit] do
            resources :purchase_receipt_items, except: [:new, :edit]
          end
          resources :schemes, only: [:create, :update, :index, :show]
          resources :vendor_supplier_contracts, only: [:create, :update, :index, :show]
          resources :supplier_skus, only: [:create, :update, :index, :show]
        end
      end
    end
  end
end
