RSpec.describe Api::Public::V1::PurchaseReceiptsController, type: :controller do
  let(:current_vendor) { Api::Public::BaseController.new.current_vendor }
  let(:current_user) { ApplicationController.new.current_user }

  let(:supplier) { FactoryBot.create(:supplier) }

  let(:sku) { FactoryBot.create(:sku) }
  let(:sku2) { FactoryBot.create(:sku) }
  let(:sku3) { FactoryBot.create(:sku) }

  let(:purchase_order_item1) { FactoryBot.create(:purchase_order_item, sku: sku) }
  let(:purchase_order_item2) { FactoryBot.create(:purchase_order_item, sku: sku) }
  let(:purchase_order_item3) { FactoryBot.create(:purchase_order_item, sku: sku2, 
                                                  purchase_order: purchase_order_item1.purchase_order) }

  let(:purchase_order_ids) { [purchase_order_item1.purchase_order.id, purchase_order_item2.purchase_order.id] }
  let(:desired_quantity_sku) { purchase_order_item1.quantity + purchase_order_item2.quantity }
  let(:desired_quantity_sku2) { purchase_order_item3.quantity }

  let(:purchase_receipt) { FactoryBot.create(:purchase_receipt, user: current_user, vendor: current_vendor) }
  let(:other_user_purchase_receipt) { FactoryBot.create(:purchase_receipt) }

  describe 'GET #index' do
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
      end
    end

    context 'when no filters are applied' do
      it 'should return valid purchase receipts' do
        FactoryBot.create_list(:purchase_receipt, 5, user: current_user, vendor: current_vendor)
        purchase_receipts = PurchaseReceipt.all
        get :index, params: {}

        expected_response = purchase_receipts.map do |purchase_receipt|
          purchase_receipt.slice(:id, :supplier_id, :vendor_id, :code,
                                 :total_amount, :status, :created_at, :updated_at)
            .merge(supplier_name: purchase_receipt.supplier.name)
        end

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_response.count).at_path('data')
        expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')
      end
    end

    context 'when id filter is applied' do
      it 'should return valid purchase receipts' do
        FactoryBot.create_list(:purchase_receipt, 5, user: current_user, vendor: current_vendor)
        get :index, params: { id: PurchaseReceipt.first.id }

        expected_response = [
          PurchaseReceipt.first.slice(:id, :supplier_id, :vendor_id, :code,
                                      :total_amount, :status, :created_at, :updated_at)
            .merge(supplier_name: PurchaseReceipt.first.supplier.name)
        ]

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_response.count).at_path('data')
        expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')
      end
    end

    context 'when supplier name filter is applied' do
      it 'should return valid purchase receipts' do
        FactoryBot.create(:supplier, name: 'kamal')
        FactoryBot.create(:supplier, name: 'Anubhav')
        FactoryBot.create(:purchase_receipt, user: current_user, vendor: current_vendor, supplier: Supplier.first)
        FactoryBot.create(:purchase_receipt, user: current_user, vendor: current_vendor, supplier: Supplier.second)

        get :index, params: { supplier_name: Supplier.first.name }

        expected_response = [
          PurchaseReceipt.first.slice(:id, :supplier_id, :vendor_id, :code,
                                      :total_amount, :status, :created_at, :updated_at)
            .merge(supplier_name: PurchaseReceipt.first.supplier.name)
        ]

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_response.count).at_path('data')
        expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')
      end
    end

    context 'when status filter is applied' do
      it 'should return valid purchase receipts' do
        FactoryBot.create(:purchase_receipt, user: current_user, vendor: current_vendor, status: :created)
        FactoryBot.create(:purchase_receipt, user: current_user, vendor: current_vendor, status: :pending)

        get :index, params: { status: 'created' }

        expected_response = [
          PurchaseReceipt.first.slice(:id, :supplier_id, :vendor_id, :code,
                                      :total_amount, :status, :created_at, :updated_at)
            .merge(supplier_name: PurchaseReceipt.first.supplier.name)
        ]

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_response.count).at_path('data')
        expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')
      end
    end

    context 'when created_from filter is applied' do
      it 'should return purchase receipts created after provided date' do
        FactoryBot.create_list(:purchase_receipt, 5, user: current_user, vendor: current_vendor, created_at: 10.days.ago)

        created_from = 11.day.ago
        expected_data = current_vendor.purchase_receipts
                          .where('created_at >= ?', created_from.to_date.beginning_of_day)
                          .map do |purchase_receipt|
          purchase_receipt.slice(:id, :supplier_id, :vendor_id, :code,
                                 :total_amount, :status, :created_at, :updated_at)
            .merge(supplier_name: purchase_receipt.supplier.name)
        end

        get :index, params: { created_from: created_from.to_date.to_s }

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when created_to filter is applied' do
      it 'should return purchase receipts created before provided date' do
        FactoryBot.create_list(:purchase_receipt, 5, user: current_user, vendor: current_vendor)

        created_to = 3.day.ago
        expected_data = current_vendor.purchase_receipts.
          where('created_at <= ?', created_to.to_date.end_of_day)
                          .map do |purchase_receipt|
          purchase_receipt.slice(:id, :supplier_id, :vendor_id, :code,
                                 :total_amount, :status, :created_at, :updated_at)
            .merge(supplier_name: purchase_receipt.supplier.name)
        end

        get :index, params: { created_to: created_to.to_date.to_s }
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end
  end

  describe 'POST #verify' do
    before(:each) do
      request.headers.merge!({
        "CONTENT_TYPE" => 'application/json'
      })
    end

    context 'Invalid Parameters' do
      context 'purchase_order_ids' do
        it 'should raise error if not present' do
          post :verify, params: { sku_quantities: [ { sku_id: 123, quantity: 100 } ] }
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to be_json_eql({ 'message': 'Parameter purchase_order_ids is required' }.to_json).at_path('errors/0')
        end

        it 'should raise error if empty array' do
          post :verify, params: { purchase_order_ids: [] }
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to be_json_eql({ 'message': 'Parameter purchase_order_ids cannot be blank' }.to_json).at_path('errors/0')
        end

        it 'should raise error if item in array is not an integer' do
          post :verify, params: { purchase_order_ids: ['invalid'] }
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'sku_quantities' do
        it 'should raise error if not present' do
          post :verify, params: { purchase_order_ids: [3] }
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to be_json_eql({ 'message': 'Parameter sku_quantities is required' }.to_json).at_path('errors/0')
        end

        it 'should raise error if empty array' do
          post :verify, params: { purchase_order_ids: [3], sku_quantities: [] }
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to be_json_eql({ 'message': 'Parameter sku_quantities cannot be blank' }.to_json).at_path('errors/0')
        end

        it 'should raise error if sku_id not present' do
          post :verify, params: { purchase_order_ids: [3], sku_quantities: [{}] }
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to be_json_eql({ 'message': 'Parameter sku_id is required' }.to_json).at_path('errors/0')
        end

        it 'should raise error if quantity not present' do
          post :verify, params: { purchase_order_ids: [3], sku_quantities: [{ sku_id: 123 }] }
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to be_json_eql({ 'message': 'Parameter quantity is required' }.to_json).at_path('errors/0')
        end
      end
    end

    context 'Valid Parameters' do
      context 'sku: shortage, sku2: extra, sku3: not in PO, sku4: unavailable' do
        it 'should provide required response' do
          post :verify, params: { 
                                  purchase_order_ids: purchase_order_ids,
                                  sku_quantities: [ { sku_id: sku.id, quantity: desired_quantity_sku - 5 },
                                                    { sku_id: sku2.id, quantity: desired_quantity_sku2 + 15 },
                                                    { sku_id: sku3.id, quantity: 100 },
                                                    { sku_id: (Sku.last.id + 100), quantity: 100 } ]
                                }

          expected_response = {
                                purchase_order_ids: purchase_order_ids,
                                result: {
                                  unavailable: [ { sku_id: (Sku.last.id + 100), quantity: 100 } ],
                                  shortages: [ { sku_id: sku.id, quantity: 5 } ],
                                  extra: [ { sku_id: sku2.id, quantity: 15 } ],
                                  not_in_po: [ { sku_id: sku3.id, quantity: 100 } ],
                                  fulfilled: [ { sku_id: sku.id, quantity: desired_quantity_sku - 5 },
                                              { sku_id: sku2.id, quantity: desired_quantity_sku2 } ]
                                }
                              }

          expect(response).to have_http_status(:ok)
          expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')
        end
      end
    end
  end

  describe 'POST #verify_csv' do
    before(:each) do
      request.headers.merge!({
        "CONTENT_TYPE" => 'application/json'
      })
    end

    context 'Invalid Parameters' do
      context 'purchase_order_ids' do
        it 'should raise error if not present' do
          post :verify_csv, params: {}
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to be_json_eql({ 'message': 'Parameter purchase_order_ids is required' }.to_json).at_path('errors/0')
        end

        it 'should raise error if empty array' do
          post :verify_csv, params: { purchase_order_ids: [] }
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to be_json_eql({ 'message': 'Parameter purchase_order_ids cannot be blank' }.to_json).at_path('errors/0')
        end

        it 'should raise error if item in array is not an integer' do
          post :verify_csv, params: { purchase_order_ids: ['invalid'] }
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'file' do
        it 'should raise error if not present' do
          post :verify_csv, params: { purchase_order_ids: [3, 4] }
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to be_json_eql({ 'message': 'Parameter file is required' }.to_json).at_path('errors/0')
        end
      end
    end

    context 'Valid Parameters' do
      context 'sku: shortage, sku2: extra, sku3: not in PO, sku4: unavailable' do
        it 'should provide required response' do
          CSV.open("/tmp/file.csv", "wb") do |csv|
            csv << ['Sku ID', 'Quantity']
            csv << [sku.id, desired_quantity_sku - 5]
            csv << [sku2.id, desired_quantity_sku2 + 15]
            csv << [sku3.id, 100]
            csv << [5000, 100]
          end

          post :verify_csv, params: {
                                      purchase_order_ids: purchase_order_ids,
                                      file: Rack::Test::UploadedFile.new("/tmp/file.csv", "text/csv")
                                    }

          expected_response = {
                                purchase_order_ids: purchase_order_ids,
                                result: {
                                  unavailable: [ { sku_id: 5000, quantity: 100 } ],
                                  shortages: [ { sku_id: sku.id, quantity: 5 } ],
                                  extra: [ { sku_id: sku2.id, quantity: 15 } ],
                                  not_in_po: [ { sku_id: sku3.id, quantity: 100 } ],
                                  fulfilled: [ { sku_id: sku.id, quantity: desired_quantity_sku - 5 },
                                              { sku_id: sku2.id, quantity: desired_quantity_sku2 } ]
                                }
                              }

          expect(response).to have_http_status(:ok)
          expect(response.body).to be_json_eql(expected_response.to_json).at_path('data')
        end
      end
    end
  end
end
