RSpec.describe Api::Public::V1::LocationsController, type: :controller, skip_auth: true do
  let(:location) { FactoryBot.create(:location, vendor: Vendor.first) }
  let(:default_attributes) { [:id, :vendor_id, :aisle, :rack, :slab, :bin, :created_at, :updated_at] }

  describe '#show' do
    context 'when id is invalid' do
      it 'should return not found' do
        get :show, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when id is valid' do
      it 'should return location instance' do
        get :show, params: { id: location.id }

        expected_data = location.slice(default_attributes)
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end
  end

  describe '#index' do
    context 'when given invalid parameters' do
      it 'should return bad request' do
        get :index, params: { aisle: '' }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { rack: '' }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { slab: '' }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { bin: '' }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when no filters are applied' do
      it 'should return valid locations' do
        FactoryBot.create_list(:location, 5, vendor: Vendor.first)
        locations = Location.all
        get :index, params: {}

        expected_data = locations.map do |location|
                          location.slice(default_attributes)
                        end
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when aisle filter is applied' do
      it 'should return valid locations' do
        FactoryBot.create_list(:location, 2, vendor: Vendor.first)
        get :index, params: { aisle: Location.first.aisle }

        expected_data = [Location.first.slice(default_attributes)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when rack filter is applied' do
      it 'should return valid locations' do
        FactoryBot.create_list(:location, 2, vendor: Vendor.first)
        get :index, params: { rack: Location.second.rack }

        expected_data = [Location.second.slice(default_attributes)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when slab filter is applied' do
      it 'should return valid locations' do
        FactoryBot.create_list(:location, 2, vendor: Vendor.first)
        get :index, params: { slab: Location.first.slab }

        expected_data = [Location.first.slice(default_attributes)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when bin filter is applied' do
      it 'should return valid locations' do
        FactoryBot.create_list(:location, 2, vendor: Vendor.first)
        get :index, params: { bin: Location.second.bin }

        expected_data = [Location.second.slice(default_attributes)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when pagination is applied' do
      it 'should return paginated results' do
        FactoryBot.create_list(:location, 5, vendor: Vendor.first)
        get :index, params: { page: 2, per_page: 1 }

        expected_data = [Location.second.slice(default_attributes)]
        expected_meta = { total_pages: 5, total_count: 5, page: 2 }
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
        expect(response.body).to be_json_eql(expected_meta.to_json).at_path('meta')
      end
    end
  end

  describe '#create' do
    context 'when parameters are not valid' do
      it 'should raise bad request' do
        post :create
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          location: {
            ailse: 'Aisle',
            rack: 'Rack',
            slab: 'Slab'
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          location: {
            ailse: 'Aisle',
            rack: 'Rack',
            bin: 'Bin'
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          location: {
            ailse: 'Aisle',
            slab: 'Slab',
            bin: 'Bin'
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          location: {
            rack: 'Rack',
            slab: 'Slab',
            bin: 'Bin'
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          location: {
            aisle: '',
            rack: '',
            slab: '',
            bin: ''
          }
        }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when parameters are valid' do
      it 'should create location' do
        old_location_count = Location.count
        post :create, params: {
          location: {
            aisle: 'Aisle',
            rack: 'Rack',
            slab: 'Slab',
            bin: 'Bin'
          }
        }
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(Location.last.slice(default_attributes).to_json).at_path('data')
        new_location_count = Location.count
        expect(new_location_count - old_location_count).to be 1
      end
    end
  end

  describe '#update' do
    context 'when parameters are not valid' do
      it 'should raise bad request' do
        put :update, params: {
          id: location.id,
          location: {
            ailse: 'Aisle',
            rack: 'Rack',
            slab: 'Slab',
            bin: ''
          }
        }
        expect(response).to have_http_status(:bad_request)

        put :update, params: {
          id: location.id,
          location: {
            ailse: 'Aisle',
            rack: 'Rack',
            slab: '',
            bin: 'Bin'
          }
        }
        expect(response).to have_http_status(:bad_request)

        put :update, params: {
          id: location.id,
          location: {
            ailse: 'Aisle',
            rack: '',
            slab: 'Slab',
            bin: 'Bin'
          }
        }
        expect(response).to have_http_status(:bad_request)

        put :update, params: {
          id: location.id,
          location: {
            aisle: '',
            rack: 'Rack',
            slab: 'Slab',
            bin: 'Bin'
          }
        }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when parameters are valid' do
      it 'should update location' do
        put :update, params: {
          id: location.id,
          location: {
            aisle: 'Aisle',
            rack: 'Rack',
            slab: 'Slab',
            bin: 'Bin'
          }
        }
        expect(response).to have_http_status(:ok)
        expected_location = location.slice(default_attributes)
        expected_location[:aisle] = 'Aisle'
        expected_location[:rack] = 'Rack'
        expected_location[:slab] = 'Slab'
        expected_location[:bin] = 'Bin'
        expect(response.body).to be_json_eql(expected_location.to_json).at_path('data')
      end
    end
  end
end
