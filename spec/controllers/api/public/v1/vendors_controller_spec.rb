RSpec.describe Api::Public::V1::VendorsController, type: :controller, skip_auth: true do
  let(:vendor) { FactoryBot.create(:vendor) }

  describe '#show' do
    context 'when id is invalid' do
      it 'should return not found' do
        get :show, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when id is valid' do
      it 'should return vendor instance' do
        get :show, params: { id: vendor.id }

        expected_data = vendor.slice(:id, :name, :status, :metadata, :invoice_number_template, :created_at, :updated_at)
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end
  end

  describe '#index' do
    context 'when no filters are applied' do
      it 'should return valid vendors' do
        FactoryBot.create_list(:vendor, 5)
        vendors = Vendor.all
        get :index, params: {}

        expected_data = vendors.map do |vendor|
                          vendor.slice(:id, :name, :status, :metadata, :invoice_number_template, :created_at, :updated_at)
                        end
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when mrp item_group_filter is applied' do
      it 'should return valid vendors' do
        FactoryBot.create_list(:vendor, 2)
        FactoryBot.create(:vendor, status: :inactive)
        get :index, params: { status: Vendor.last.status }

        expected_data = [Vendor.last.slice(:id, :name, :status, :metadata, :invoice_number_template, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end
  end

  describe '#create' do
    context 'when parameters are not valid' do
      it 'should raise bad request' do
        post :create
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          vendor: {
            name: 'Vendor 123'
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          vendor: {
            invoice_number_template: 'ABCDE12345'
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          vendor: {
            name: '',
            invoice_number_template: 'ABCDE12345'
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          vendor: {
            name: 'Vendor 123',
            invoice_number_template: ''
          }
        }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when parameters are valid' do
      it 'should create vendor' do
        old_vendor_count = Vendor.count
        post :create, params: {
          vendor: {
            name: 'Vendor 123',
            invoice_number_template: 'ABCDE12345'
          }
        }
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(Vendor.last.slice(:id, :name, :status, :metadata, :invoice_number_template, :created_at, :updated_at).to_json).at_path('data')
        new_vendor_count = Vendor.count
        expect(new_vendor_count - old_vendor_count).to be 1
      end
    end
  end

  describe '#update' do
    context 'when parameters are not valid' do
      it 'should raise bad request' do
        put :update, params: {
          id: vendor.id,
          vendor: {
            name: '',
            invoice_number_template: 'ABCDE12345'
          }
        }
        expect(response).to have_http_status(:bad_request)

        put :update, params: {
          id: vendor.id,
          vendor: {
            name: 'Vendor 123',
            invoice_number_template: ''
          }
        }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when parameters are valid' do
      it 'should update vendor' do
        put :update, params: {
          id: vendor.id,
          vendor: {
            name: 'Vendor ABC',
            invoice_number_template: 'NEWTEMPLATE 123'
          }
        }
        expect(response).to have_http_status(:ok)
        expected_vendor = vendor.slice(:id, :name, :status, :metadata, :invoice_number_template, :created_at, :updated_at)
        expected_vendor[:name] = 'Vendor ABC'
        expected_vendor[:invoice_number_template] = 'NEWTEMPLATE 123'
        expect(response.body).to be_json_eql(expected_vendor.to_json).at_path('data')
      end
    end
  end
end