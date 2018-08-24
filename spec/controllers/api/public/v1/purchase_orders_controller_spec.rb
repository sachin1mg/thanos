RSpec.describe Api::Public::V1::PurchaseOrdersController, type: :controller do
  let(:supplier) { FactoryBot.create(:supplier) }
  let(:sku) { FactoryBot.create(:sku) }
  let(:current_vendor) { Api::Public::BaseController.new.current_vendor }
  let(:current_user) { ApplicationController.new.current_user }
  let(:purchase_order) { FactoryBot.create(:purchase_order, user: current_user, vendor: current_vendor) }
  let(:other_user_purchase_order) { FactoryBot.create(:purchase_order) }

  describe '#index' do
    context 'Invalid filters applied' do
      it 'should return bad request' do
        get :index, params: { id: 'INVALID_ID' }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { status: '' }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { supplier_name: '' }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { created_from: 'invalid date' }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { created_to: 'invalid date' }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { per_page: 0 }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { page: 0 }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when no filters are applied' do
      it 'should return valid purchase orders' do
        FactoryBot.create_list(:purchase_order, 5, user: current_user, vendor: current_vendor)
        purchase_orders = PurchaseOrder.all
        get :index, params: {}

        expected_response = purchase_orders.map do |purchase_order|
          purchase_order.slice(:id, :supplier_id, :vendor_id, :code, :status,
                               :type, :created_at, :updated_at)
                               .merge(supplier_name: purchase_order.supplier.name)
        end

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_response.count).at_path('data')
        expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')
      end
    end

    context 'when id filter is applied' do
      it 'should return valid purchase order' do
        FactoryBot.create_list(:purchase_order, 5, user: current_user, vendor: current_vendor)
        get :index, params: { id: PurchaseOrder.first.id }

        expected_response = [
          PurchaseOrder.first.slice(:id, :supplier_id, :vendor_id,
            :code, :status, :type, :created_at, :updated_at)
            .merge(supplier_name: PurchaseOrder.first.supplier.name)
        ]

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_response.count).at_path('data')
        expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')
      end
    end

    context 'when supplier name filter is applied' do
      it 'should return valid purchase orders' do
        FactoryBot.create(:supplier, name: 'kamal')
        FactoryBot.create(:supplier, name: 'Anubhav')
        FactoryBot.create(:purchase_order, user: current_user, vendor: current_vendor, supplier: Supplier.first)
        FactoryBot.create(:purchase_order, user: current_user, vendor: current_vendor, supplier: Supplier.second)

        get :index, params: { supplier_name: Supplier.first.name }

        expected_response = [
          PurchaseOrder.first.slice(:id, :supplier_id, :vendor_id,
                                    :code, :status, :type, :created_at, :updated_at)
                                    .merge(supplier_name: PurchaseOrder.first.supplier.name)
        ]

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_response.count).at_path('data')
        expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')
      end
    end

    context 'when status filter is applied' do
      it 'should return valid purchase orders' do
        FactoryBot.create(:purchase_order, user: current_user, vendor: current_vendor, status: :created)
        FactoryBot.create(:purchase_order, user: current_user, vendor: current_vendor, status: :pending)

        get :index, params: { status: 'created' }

        expected_response = [
          PurchaseOrder.first.slice(:id, :supplier_id, :vendor_id,
                                    :code, :status, :type, :created_at, :updated_at)
                                    .merge(supplier_name: PurchaseOrder.first.supplier.name)
        ]

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_response.count).at_path('data')
        expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')
      end
    end

    context 'when created_from filter is applied' do
      it 'should return purchase orders created after provided date' do
        FactoryBot.create_list(:purchase_order, 5, user: current_user, vendor: current_vendor, created_at: 10.days.ago)

        created_from = 11.day.ago
        expected_data = current_vendor.purchase_orders
                          .where('created_at >= ?', created_from.to_date.beginning_of_day)
                          .map do |purchase_order|
                             purchase_order.slice(:id, :supplier_id, :vendor_id,
                                                  :code, :status, :type, :created_at, :updated_at)
                                                  .merge(supplier_name: purchase_order.supplier.name)
                           end

        get :index, params: { created_from: created_from.to_date.to_s }

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when created_to filter is applied' do
      it 'should return purchase orders created before provided date' do
        FactoryBot.create_list(:purchase_order, 5, user: current_user, vendor: current_vendor)

        created_to = 3.day.ago
        expected_data = current_vendor.purchase_orders.
          where('created_at <= ?', created_to.to_date.end_of_day)
                          .map do |purchase_order|
                             purchase_order.slice(:id, :supplier_id, :vendor_id,
                                                  :code, :status, :type, :created_at, :updated_at)
                                                  .merge(supplier_name: purchase_order.supplier.name)
                           end

        get :index, params: { created_to: created_to.to_date.to_s }
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when pagination is applied' do
      it 'should return paginated results' do
        FactoryBot.create_list(:purchase_order, 5, user: current_user, vendor: current_vendor)
        purchase_order = PurchaseOrder.second
        get :index, params: { page: 2, per_page: 1 }

        expected_data = [purchase_order.slice(:id, :supplier_id, :vendor_id,
                         :code, :status, :type, :created_at, :updated_at)
                         .merge(supplier_name: purchase_order.supplier.name)]
        expected_meta = { total_pages: 5, total_count: 5, page: 2 }
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
        expect(response.body).to be_json_eql(expected_meta.to_json).at_path('meta')
      end
    end

    context 'when pagination is applied with more than maximum page no' do
      it 'should return empty results' do
        FactoryBot.create_list(:purchase_order, 5, user: current_user, vendor: current_vendor)
        get :index, params: { page: 6, per_page: 1 }

        expected_meta = { total_pages: 5, total_count: 5, page: 6 }
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size([].count).at_path('data')
        expect(response.body).to be_json_eql([].to_json).at_path('data')
        expect(response.body).to be_json_eql(expected_meta.to_json).at_path('meta')
      end
    end

    context 'when pagination is applied with filter' do
      it 'should return paginated results' do
        FactoryBot.create_list(:purchase_order, 5, user: current_user, vendor: current_vendor)
        purchase_order = PurchaseOrder.second
        get :index, params: { page: 1, per_page: 2, id: purchase_order.id }

        expected_data = [purchase_order.slice(:id, :supplier_id, :vendor_id, :code,
                                              :status, :type, :created_at, :updated_at)
                                              .merge(supplier_name: purchase_order.supplier.name)]
        expected_meta = { total_pages: 1, total_count: 1, page: 1 }
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
        expect(response.body).to be_json_eql(expected_meta.to_json).at_path('meta')
      end
    end
  end

  describe '#show' do
    context 'when id is invalid' do
      it 'should return not found' do
        @request.env['HTTP_ACCEPT'] = 'application/json'
        @request.env['CONTENT_TYPE'] = 'application/json'
        get :show, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when id is valid but purchase order not belongs to logged in user' do
      it 'should return not found' do
        @request.env['HTTP_ACCEPT'] = 'application/json'
        @request.env['CONTENT_TYPE'] = 'application/json'
        get :show, params: { id: other_user_purchase_order.id }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when id is valid and purchase order belongs to logged in user' do
      it 'should return purchase order instance' do
        @request.env['HTTP_ACCEPT'] = 'application/json'
        @request.env['CONTENT_TYPE'] = 'application/json'
        get :show, params: { id: purchase_order.id }

        expected_response = purchase_order.slice(:id, :supplier_id, :vendor_id,
                                                 :code, :status, :type,
                                                 :created_at, :updated_at)
        expected_response[:supplier_name] = purchase_order.supplier.name
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')
      end
    end
  end

  describe '#create' do
    context 'when parameters are not valid' do
      it 'should raise bad request' do
        post :create
        expect(response).to have_http_status(:bad_request)
      end

      it 'should rails bad request when supplier_id is not present.' do
        post :create, params: {
          purchase_order: {
            code: 'po1',
            metadata: {}
          }
        }

        expect(response).to have_http_status(:bad_request)
      end

      it 'should rails bad request when code is not present.' do
        post :create, params: {
          purchase_order: {
            supplier_id: supplier.id,
            metadata: {}
          }
        }

        expect(response).to have_http_status(:bad_request)
      end

      it 'should rails bad request when purchase_order_item is not present.' do
        post :create, params: {
          purchase_order: {
            supplier_id: 1,
            code: 'po1'
          }
        }

        expect(response).to have_http_status(:bad_request)
      end

      it 'should rails bad request when sku_id is not present in purchase_order_items list' do
        post :create, params: {
          purchase_order: {
            supplier_id: supplier.id,
            code: 'po1',
            purchase_order_items: [
              {
                quantity: 100,
                price: 10.0,
                schedule_date: Date.today
              }
            ]
          }
        }

        expect(response).to have_http_status(:bad_request)
      end

      it 'should rails bad request when quantity is negative.' do
        post :create, params: {
          purchase_order: {
            supplier_id: supplier.id,
            code: 'po1',
            purchase_order_items: [
              {
                sku_id: sku.id,
                quantity: -100,
                price: 10.0,
                schedule_date: Date.today
              }
            ]
          }
        }

        expect(response).to have_http_status(:bad_request)
      end

      it 'should rails bad request when price is negative.' do
        post :create, params: {
          purchase_order: {
            supplier_id: supplier.id,
            code: 'po1',
            purchase_order_items: [
              {
                sku_id: sku.id,
                quantity: 100,
                price: -10.0,
                schedule_date: Date.today
              }
            ]
          }
        }

        expect(response).to have_http_status(:bad_request)
      end

    end

    context 'when valid_create' do
      it 'should create purchase order and purchase order items.' do
        old_po_count = PurchaseOrder.count

        post :create, params: {
          purchase_order: {
            supplier_id: supplier.id,
            code: 'po1',
            purchase_order_items: [
              {
                sku_id: sku.id,
                quantity: 101,
                price: 10.0,
                schedule_date: Date.today
              }
            ]
          }
        }

        expect(response).to have_http_status(:ok)
        expected_response = PurchaseOrder.last.slice(:id, :supplier_id, :vendor_id,
                                                     :code, :status, :type,
                                                     :created_at, :updated_at)
        expected_response[:supplier_name] = PurchaseOrder.last.supplier.name

        expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')

        new_po_count = PurchaseOrder.count
        expect(new_po_count - old_po_count).to be 1
        expect(PurchaseOrder.first.purchase_order_items.count).to eq(1)
      end
    end
  end

  describe '#update' do
    context 'when parameters are not valid' do
      it 'should raise bad request' do
        put :update, params:{
          id: purchase_order.id
        }

        expect(response).to have_http_status(:bad_request)
      end

      it 'should raise bad request when status is not in (cancelled, closed)' do
        put :update, params:{
          id: purchase_order.id,
          purchase_order: {
            status: 'random'
          }
        }

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when parameters are valid but purchase order not belongs to current user' do
      it 'should not update sku' do
        expect(other_user_purchase_order.status).to eq('created')

        put :update, params: {
          id: other_user_purchase_order.id,
          purchase_order: {
            status: 'cancelled'
          }
        }

        expect(response).to have_http_status(:not_found)
        expect(other_user_purchase_order.status).to eq('created')
      end
    end

    context 'when parameters are valid' do
      it 'should update sku' do
        put :update, params: {
          id: purchase_order.id,
          purchase_order: {
            status: 'cancelled'
          }
        }
        expect(response).to have_http_status(:ok)
        expected_response = purchase_order.reload.slice(:id, :supplier_id, :vendor_id,
                                                        :code, :status, :type,
                                                        :created_at, :updated_at)
        expected_response[:supplier_name] = purchase_order.supplier.name
        expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')
      end
    end
  end
end
