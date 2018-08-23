RSpec.describe Api::Public::V1::MaterialRequestsController, type: :controller do
  let!(:default_attributes) { [:id, :sku_id, :quantity, :status, :created_at] }
  let!(:sku_default_attributes) { [:id, :onemg_sku_id, :sku_name, :manufacturer_name, :item_group, :uom, :pack_size] }
  let!(:current_vendor) { Api::Public::BaseController.new.current_vendor }
  let!(:current_user) { ApplicationController.new.current_user }
  
  describe 'GET #index' do
    before(:each) do
      FactoryBot.create_list(:material_request, 5, vendor: current_vendor, user: current_user)
      request.headers.merge!({
        "ACCEPT" => 'application/json'
      })
    end

    context 'Invalid filters applied' do
      it 'should return bad request' do
        get :index, params: { status: '' }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { created_from: 'invalid date' }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { created_to: 'invalid date' }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'No filters applied' do
      it 'should return material_requests for current vendor only' do
        FactoryBot.create_list(:material_request, 5)
        material_requests = MaterialRequest.where(vendor: current_vendor)
        expected_data = material_requests.map do |material_request|
                          material_request.slice(default_attributes).merge(sku: material_request.sku.slice(sku_default_attributes))
                        end

        get :index, params: {}

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'Filter by id' do
      it 'should return material_requests filtered by id' do
        random_id = current_vendor.material_requests.pluck(:id).sample
        expected_data = current_vendor.material_requests.where(id: random_id).map do |material_request|
                          material_request.slice(default_attributes).merge(sku: material_request.sku.slice(sku_default_attributes))
                        end

        get :index, params: { id: random_id }

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'Filter by status' do
      it 'should return material_requests filtered by status' do
        random_id = current_vendor.material_requests.pluck(:id).sample
        MaterialRequest.find(random_id).pending!

        expected_data = current_vendor.material_requests.where(status: :pending).map do |material_request|
                          material_request.slice(default_attributes).merge(sku: material_request.sku.slice(sku_default_attributes))
                        end

        get :index, params: { status: :pending }

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'Filter by created_from' do
      it 'should return material_requests created after provided date' do
        FactoryBot.create_list(:material_request, 5, vendor: current_vendor, user: current_user, created_at: 10.days.ago)
        created_from = 3.day.ago
        expected_data = current_vendor.material_requests.
                        where('created_at >= ?', created_from.to_date.beginning_of_day).
                        map do |material_request|
                          material_request.slice(default_attributes).merge(sku: material_request.sku.slice(sku_default_attributes))
                        end

        get :index, params: { created_from: created_from.to_date.to_s }

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'Filter by created_to' do
      it 'should return material_requests created before provided date' do
        FactoryBot.create_list(:material_request, 5, vendor: current_vendor, user: current_user, created_at: 10.days.ago)
        created_to = 3.day.ago
        expected_data = current_vendor.material_requests.
                        where('created_at <= ?', created_to.to_date.end_of_day).
                        map do |material_request|
                          material_request.slice(default_attributes).merge(sku: material_request.sku.slice(sku_default_attributes))
                        end

        get :index, params: { created_to: created_to.to_date.to_s }

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when pagination is applied' do
      it 'should return paginated results' do
        get :index, params: { page: 2, per_page: 1 }

        expected_data = [MaterialRequest.second.slice(default_attributes).merge(sku: MaterialRequest.second.sku.slice(sku_default_attributes))]
        expected_meta = { total_pages: 5, total_count: 5, page: 2 }
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
        expect(response.body).to be_json_eql(expected_meta.to_json).at_path('meta')
      end
    end
  end

  describe 'GET #show' do
    context 'when id is invalid' do
      it 'should return not found' do
        material_request = FactoryBot.create(:material_request, user: current_user, vendor: current_vendor)
        get :show, params: { id: material_request.id + 10 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when id is valid' do
      it 'should return material_request instance' do
        material_request = FactoryBot.create(:material_request, user: current_user, vendor: current_vendor)
        expected_mr = MaterialRequest.find(material_request.id)
        expected_data = expected_mr.slice(default_attributes)
        expected_data[:sku] = expected_mr.sku.slice(sku_default_attributes)

        get :show, params: { id: material_request.id }

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end
  end
end
