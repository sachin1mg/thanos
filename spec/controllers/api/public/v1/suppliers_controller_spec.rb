RSpec.describe Api::Public::V1::SuppliersController, type: :controller, skip_auth: true do
  let(:supplier) { FactoryBot.build(:supplier, :active) }

  describe '#index' do
    context 'when no filters are applied' do
      it 'should return valid suppliers' do
        FactoryBot.create_list(:supplier, 4)
        
        get :index
        expected_data = Supplier.all.map do |supplier|
                          supplier.slice(:id, :name, :status, :types, :metadata, :created_at, :updated_at, :deleted_at)
                        end
        
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when name filter is applied' do
      it 'should return filtered suppliers' do
        name_query = 'han'
        FactoryBot.create(:supplier, name: 'rohan')
        FactoryBot.create(:supplier, name: 'kartik')
        FactoryBot.create(:supplier, name: 'mohan')

        get :index, params: { name: name_query }

        expected_data = Supplier.search(name_query).map do |supplier|
                          supplier.slice(:id, :name, :status, :types, :metadata, :created_at, :updated_at, :deleted_at)
                        end
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end
  end

  describe '#show' do
    context 'when id is invalid' do
      it 'should return not found' do
        get :show, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when id is valid' do
      it 'should return supplier instance' do
        supplier.save!
        get :show, params: { id: supplier.id }
        expected_data = Supplier.find(supplier.id).as_json

        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end
  end

  describe '#create' do
    context 'no params' do
      it 'should raise bad request' do
        post :create
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'blank name' do
      it 'should raise bad request' do
        post :create, params: { name: '' }
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to be_json_eql({ 'message': 'Parameter name cannot be blank' }.to_json).at_path('errors/0')
      end
    end

    context 'invalid status if present' do
      it 'should raise bad request' do
        post :create, params: { name: 'Supplier 100', status: 'invalid' }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'valid name' do
      it 'should create a supplier with default values' do
        post :create, params: { name: supplier.name }

        created_supplier = Supplier.last
        expected_data = created_supplier.slice(:id, :name, :status, :types, :metadata, :created_at, :updated_at, :deleted_at)

        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
        expect(Supplier.all.count).to be(1)
        expect(created_supplier.status).to eq 'active'
        expect(created_supplier.types).to eq []
      end
    end

    context 'valid parameters' do
      it 'should create a supplier with provided values' do
        params = {
          name: 'Supplier 100',
          status: 'inactive',
          types: ['one', 'two'],
          metadata: { random_key: 'random value' }
        }
        post :create, params: params

        created_supplier = Supplier.last
        expected_data = created_supplier.slice(:id, :name, :status, :types, :metadata, :created_at, :updated_at, :deleted_at)

        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
        expect(Supplier.all.count).to be(1)
        expect(created_supplier.status).to eq(params[:status])
        expect(created_supplier.types).to eq(params[:types])
        expect(created_supplier.metadata).to eq(params[:metadata].as_json)
      end
    end
  end

  
end
