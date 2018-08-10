RSpec.describe Api::Public::V1::SalesOrdersController, type: :controller, skip_auth: true do
  let(:sku) { FactoryBot.create(:sku) }
  before(:all) { Sidekiq::Testing.inline! }
  after(:all) { Sidekiq::Testing.fake! }

  describe '#create' do
    context 'when parameters are not valid' do
      it 'should raise bad request' do
        post :create
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sales_order: {
            customer_name: 'Viren Chugh',
            amount: 200,
            discount: 50,
            source: '1mg',
            barcode: 'ASK312SADASK1231!@#',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                price: 100,
                discount: 25,
                quantity: 3,
                sku_id: sku.id
              }
            ]
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            amount: 200,
            discount: 50,
            source: '1mg',
            barcode: 'ASK312SADASK1231!@#',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                price: 100,
                discount: 25,
                quantity: 3,
                sku_id: sku.id
              }
            ]
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            customer_name: 'Viren Chugh',
            discount: 50,
            source: '1mg',
            barcode: 'ASK312SADASK1231!@#',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                price: 100,
                discount: 25,
                quantity: 3,
                sku_id: sku.id
              }
            ]
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            customer_name: 'Viren Chugh',
            amount: 200,
            source: '1mg',
            barcode: 'ASK312SADASK1231!@#',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                price: 100,
                discount: 25,
                quantity: 3,
                sku_id: sku.id
              }
            ]
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            customer_name: 'Viren Chugh',
            amount: 200,
            discount: 50,
            barcode: 'ASK312SADASK1231!@#',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                price: 100,
                discount: 25,
                quantity: 3,
                sku_id: sku.id
              }
            ]
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            customer_name: 'Viren Chugh',
            amount: 200,
            discount: 50,
            source: '1mg',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                price: 100,
                discount: 25,
                quantity: 3,
                sku_id: sku.id
              }
            ]
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            customer_name: 'Viren Chugh',
            amount: 200,
            discount: 50,
            source: '1mg',
            barcode: 'ASK312SADASK1231!@#',
            sales_order_items: [
              {
                price: 100,
                discount: 25,
                quantity: 3,
                sku_id: sku.id
              }
            ]
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            customer_name: 'Viren Chugh',
            amount: 200,
            discount: 50,
            source: '1mg',
            barcode: 'ASK312SADASK1231!@#',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                discount: 25,
                quantity: 3,
                sku_id: sku.id
              }
            ]
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            customer_name: 'Viren Chugh',
            amount: 200,
            discount: 50,
            source: '1mg',
            barcode: 'ASK312SADASK1231!@#',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                price: 100,
                quantity: 3,
                sku_id: sku.id
              }
            ]
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            customer_name: 'Viren Chugh',
            amount: 200,
            discount: 50,
            source: '1mg',
            barcode: 'ASK312SADASK1231!@#',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                price: 100,
                discount: 25,
                sku_id: sku.id
              }
            ]
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            customer_name: 'Viren Chugh',
            amount: 200,
            discount: 50,
            source: '1mg',
            barcode: 'ASK312SADASK1231!@#',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                price: 100,
                discount: 25,
                quantity: 3
              }
            ]
          }
        }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when parameters are valid' do
      it 'should create sales order' do
        old_sales_order_count = SalesOrder.count
        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            customer_name: 'Viren Chugh',
            amount: 200,
            discount: 50,
            source: '1mg',
            barcode: 'ASK312SADASK1231!@#',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                price: 100,
                discount: 25,
                quantity: 3,
                sku_id: sku.id
              }
            ]
          }
        }
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(SalesOrder.last.slice(:id, :vendor_id, :order_reference_id, :customer_name, :amount,
                                                                   :discount, :barcode, :source, :shipping_label_url, :status,
                                                                   :metadata, :deleted_at, :created_at, :updated_at).to_json).at_path('data')
        new_sales_order_count = SalesOrder.count
        expect(new_sales_order_count - old_sales_order_count).to be 1
      end
    end

    context 'when parameters are valid and quantity is more than inventory' do
      it 'should create sales order and material request' do
        old_sales_order_count = SalesOrder.count
        old_material_request_count = MaterialRequest.count
        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            customer_name: 'Viren Chugh',
            amount: 200,
            discount: 50,
            source: '1mg',
            barcode: 'ASK312SADASK1231!@#',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                price: 100,
                discount: 25,
                quantity: 103,
                sku_id: sku.id
              }
            ]
          }
        }
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(SalesOrder.last.slice(:id, :vendor_id, :order_reference_id, :customer_name, :amount,
                                                                   :discount, :barcode, :source, :shipping_label_url, :status,
                                                                   :metadata, :deleted_at, :created_at, :updated_at).to_json).at_path('data')
        new_sales_order_count = SalesOrder.count
        new_material_request_count = MaterialRequest.count
        expect(new_sales_order_count - old_sales_order_count).to be 1
        expect(new_material_request_count - old_material_request_count).to be 1
      end
    end

    context 'when parameters are valid and quantity is more than inventory and MR exists' do
      it 'should create sales order and update previous material request' do
        inventory = FactoryBot.create(:inventory)
        FactoryBot.create(:material_request, sku: inventory.sku, vendor: Vendor.first)
        old_sales_order_count = SalesOrder.count
        inventory_quantity = inventory.quantity
        old_material_request_quanity = MaterialRequest.last.quantity

        post :create, params: {
          sales_order: {
            order_reference_id: 'PO1231230',
            customer_name: 'Viren Chugh',
            amount: 200,
            discount: 50,
            source: '1mg',
            barcode: 'ASK312SADASK1231!@#',
            shipping_label_url: 'shpping.label_url.com/sample_file.pdf',
            sales_order_items: [
              {
                price: 100,
                discount: 25,
                quantity: 103,
                sku_id: inventory.sku_id
              }
            ]
          }
        }
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(SalesOrder.last.slice(:id, :vendor_id, :order_reference_id, :customer_name, :amount,
                                                                   :discount, :barcode, :source, :shipping_label_url, :status,
                                                                   :metadata, :deleted_at, :created_at, :updated_at).to_json).at_path('data')
        new_sales_order_count = SalesOrder.count
        expect(new_sales_order_count - old_sales_order_count).to be 1
        expect(MaterialRequest.last.quantity - old_material_request_quanity).to be (103 - inventory_quantity)
      end
    end
  end
end
