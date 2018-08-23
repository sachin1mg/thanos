RSpec.describe Api::Public::V1::PurchaseReceiptsController, type: :controller do
  let(:supplier) { FactoryBot.create(:supplier) }
  let(:sku) { FactoryBot.create(:sku) }
  let(:current_vendor) { Api::Public::BaseController.new.current_vendor }
  let(:current_user) { ApplicationController.new.current_user }
  let(:purchase_receipt) { FactoryBot.create(:purchase_receipt, user: current_user, vendor: current_vendor) }
  let(:other_user_purchase_receipt) { FactoryBot.create(:purchase_receipt) }

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

    context 'when pagination is applied' do
      it 'should return paginated results' do
        FactoryBot.create_list(:purchase_receipt, 5, user: current_user, vendor: current_vendor)
        purchase_receipt = PurchaseReceipt.second
        get :index, params: { page: 2, per_page: 1 }

        expected_data = [purchase_receipt.slice(:id, :supplier_id, :vendor_id, :code,
                         :total_amount, :status, :created_at, :updated_at)
                         .merge(supplier_name: purchase_receipt.supplier.name)]
        expected_meta = { total_pages: 5, total_count: 5, page: 2 }
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
        expect(response.body).to be_json_eql(expected_meta.to_json).at_path('meta')
      end
    end
  end
end
