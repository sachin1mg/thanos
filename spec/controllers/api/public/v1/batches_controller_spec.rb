RSpec.describe Api::Public::V1::BatchesController, type: :controller, skip_auth: true do
  let(:batch) { FactoryBot.create(:batch) }
  let(:sku) { FactoryBot.create(:sku) }

  describe '#show' do
    context 'when id is invalid' do
      it 'should return not found' do
        get :show, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when id is valid' do
      it 'should return batch instance' do
        get :show, params: { id: batch.id }

        expected_data = batch.slice(:id, :mrp, :code, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at)
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when id is valid and sku details is included' do
      it 'should return bacth instance with sku details' do
        get :show, params: { id: batch.id, include: 'sku' }

        expected_data = batch.slice(:id, :mrp, :manufacturing_date, :code, :expiry_date, :name, :created_at, :updated_at)
        expected_data[:sku] = batch.sku.slice(:id, :sku_name, :manufacturer_name)
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end
  end

  describe '#index' do
    context 'when given invalid parameters' do
      it 'should return bad request' do
        get :index, params: { manufacturing_date: '' }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { expiry_date: '' }
        expect(response).to have_http_status(:bad_request)

        get :index, params: { mrp: '' }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when no filters are applied' do
      it 'should return valid batches' do
        FactoryBot.create_list(:batch, 5)
        batches = Batch.all
        get :index, params: {}

        expected_data = batches.map do |batch|
                          batch.slice(:id, :mrp, :code, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at)
                        end
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when manufacturing_date filter is applied' do
      it 'should return valid batches' do
        FactoryBot.create_list(:batch, 2)
        get :index, params: { manufacturing_date: Batch.first.manufacturing_date }

        expected_data = [Batch.first.slice(:id, :mrp, :code, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when expiry_date filter is applied' do
      it 'should return valid batches' do
        FactoryBot.create_list(:batch, 2)
        get :index, params: { expiry_date: Batch.second.expiry_date }

        expected_data = [Batch.second.slice(:id, :mrp, :code, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when sku_ids filter is applied' do
      it 'should return valid batches' do
        FactoryBot.create_list(:batch, 2)
        get :index, params: { sku_ids: [Batch.first.sku_id.to_i
        ] }

        expected_data = [Batch.first.slice(:id, :mrp, :code, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when mrp filter is applied' do
      it 'should return valid batches' do
        FactoryBot.create_list(:batch, 2)
        get :index, params: { mrp: Batch.second.mrp }

        expected_data = [Batch.second.slice(:id, :mrp, :code, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when sku_name filter is applied' do
      it 'should return valid batches' do
        FactoryBot.create_list(:batch, 2)
        get :index, params: { sku_name: Batch.second.sku.sku_name }

        expected_data = [Batch.second.slice(:id, :mrp, :code, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when manufacturer_name filter is applied' do
      it 'should return valid batches' do
        FactoryBot.create_list(:batch, 2)
        get :index, params: { manufacturer_name: Batch.second.sku.manufacturer_name }

        expected_data = [Batch.second.slice(:id, :mrp, :code, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when pagination is applied' do
      it 'should return paginated results' do
        FactoryBot.create_list(:batch, 5)
        get :index, params: { page: 2, per_page: 1 }

        expected_data = [Batch.second.slice(:id, :mrp, :code, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at)]
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
        post :create, params: {
          sku_id: sku.id,
          batch: {
            mrp: 100,
            manufacturing_date: Date.today,
            expiry_date: Date.today
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sku_id: sku.id,
          batch: {
            name: 'Batch123',
            manufacturing_date: Date.today,
            expiry_date: Date.today
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sku_id: sku.id,
          batch: {
            name: 'Batch123',
            mrp: 100,
            expiry_date: Date.today
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sku_id: sku.id,
          batch: {
            name: 'Batch123',
            mrp: 100,
            manufacturing_date: Date.today,
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sku_id: sku.id,
          batch: {
            name: nil,
            mrp: nil,
            manufacturing_date: nil,
            expiry_date: nil
          }
        }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when parameters are valid' do
      it 'should create batch' do
        old_batch_count = Batch.count
        post :create, params: {
          sku_id: sku.id,
          batch: {
            name: 'Batch123',
            code: 'BatchCode',
            mrp: 100,
            manufacturing_date: Date.today,
            expiry_date: Date.today
          }
        }

        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(Batch.last.slice(:id, :mrp, :code, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at).to_json).at_path('data')
        new_batch_count = Batch.count
        expect(new_batch_count - old_batch_count).to be 1
      end
    end
  end

  describe '#update' do
    context 'when parameters are not valid' do
      it 'should raise bad request' do
        put :update, params: {
          id: batch.id,
          sku_id: batch.sku_id,
          batch: {
            name: nil,
            mrp: 100,
            manufacturing_date: Date.tomorrow,
            expiry_date: Date.tomorrow
          }
        }
        expect(response).to have_http_status(:bad_request)

        put :update, params: {
          id: batch.id,
          sku_id: batch.sku_id,
          batch: {
            name: 'BatchABC',
            mrp: nil,
            manufacturing_date: Date.tomorrow,
            expiry_date: Date.tomorrow
          }
        }
        expect(response).to have_http_status(:bad_request)

        put :update, params: {
          id: batch.id,
          sku_id: batch.sku_id,
          batch: {
            name: 'BatchABC',
            mrp: 100,
            manufacturing_date: nil,
            expiry_date: Date.tomorrow
          }
        }
        expect(response).to have_http_status(:bad_request)

        put :update, params: {
          id: batch.id,
          sku_id: batch.sku_id,
          batch: {
            name: 'BatchABC',
            mrp: 100,
            manufacturing_date: Date.tomorrow,
            expiry_date: nil
          }
        }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when parameters are valid' do
      it 'should update batch' do
        put :update, params: {
          id: batch.id,
          sku_id: batch.sku_id,
          batch: {
            name: 'BatchABC',
            mrp: 200.0,
            code: 'ABCD',
            manufacturing_date: Date.tomorrow,
            expiry_date: Date.tomorrow
          }
        }

        expect(response).to have_http_status(:ok)
        expected_batch = batch.slice(:id, :mrp, :code, :manufacturing_date, :expiry_date, :name, :created_at, :updated_at)
        expected_batch[:name] = 'BatchABC'
        expected_batch[:code] = 'ABCD'
        expected_batch[:mrp] = '200.0'
        expected_batch[:manufacturing_date] = Date.tomorrow
        expected_batch[:expiry_date] = Date.tomorrow
        expect(response.body).to be_json_eql(expected_batch.to_json).at_path('data')
      end
    end

    describe '#destroy' do
      context 'when id is invalid' do
        it 'should return not found' do
          delete :destroy, params: { id: 0, sku_id: batch.sku_id }
          expect(response).to have_http_status(:not_found)
        end
      end
  
      context 'when id is valid' do
        it 'should soft delete batch instance' do
          batch
          old_batch_count = Batch.count
          delete :destroy, params: { id: batch.id, sku_id: batch.sku_id }
          new_batch_count = Batch.count
  
          expect(response).to have_http_status(:ok)
          expect(old_batch_count - new_batch_count).to be 1
        end
      end
    end
  end
end
