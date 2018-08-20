RSpec.describe Api::Public::V1::PurchaseOrdersController, type: :controller do
  let(:supplier) { FactoryBot.create(:supplier) }
  let(:sku) { FactoryBot.create(:sku) }


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
        expected_response =  PurchaseOrder.last.slice(:id, :supplier_id, :vendor_id, :code, :status, :type,
                                                      :created_at, :updated_at)
        expected_response[:supplier_name] = PurchaseOrder.last.supplier.name

        expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')

        new_po_count = PurchaseOrder.count
        expect(new_po_count - old_po_count).to be 1
        expect(PurchaseOrder.first.purchase_order_items.count).to eq(1)
      end
    end
  end
end
