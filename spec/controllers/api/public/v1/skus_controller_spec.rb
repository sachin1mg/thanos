RSpec.describe Api::Public::V1::SkusController, type: :controller, skip_auth: true do
  let(:sku) { FactoryBot.create(:sku) }

  describe '#show' do
    context 'when id is invalid' do
      it 'should return not found' do
        get :show, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when id is valid' do
      it 'should return sku instance' do
        get :show, params: { id: sku.id }

        expected_data = sku.slice(:id, :onemg_sku_id, :sku_name, :manufacturer_name, 
                                  :item_group, :uom, :pack_size, :created_at, :updated_at)
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end
  end

  describe '#index' do
    context 'when no filters are applied' do
      it 'should return valid skus' do
        FactoryBot.create_list(:sku, 5)
        skus = Sku.all
        get :index, params: {}

        expected_data = skus.map do |sku|
                          sku.slice(:id, :onemg_sku_id, :sku_name, :manufacturer_name, 
                                    :item_group, :uom, :pack_size, :created_at, :updated_at)
                        end
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when onemg_sku_id_filter filter is applied' do
      it 'should return valid skus' do
        FactoryBot.create_list(:sku, 2)
        get :index, params: { onemg_sku_id_filter: Sku.first.onemg_sku_id }

        expected_data = [Sku.first.slice(:id, :onemg_sku_id, :sku_name, :manufacturer_name, 
                                         :item_group, :uom, :pack_size, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when manufacturer_name_filter filter is applied' do
      it 'should return valid skus' do
        FactoryBot.create_list(:sku, 2)
        get :index, params: { manufacturer_name_filter: Sku.second.manufacturer_name }

        expected_data = [Sku.second.slice(:id, :onemg_sku_id, :sku_name, :manufacturer_name, 
                                          :item_group, :uom, :pack_size, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when sku_name_filter filter is applied' do
      it 'should return valid skus' do
        FactoryBot.create_list(:sku, 2)
        get :index, params: { sku_name_filter: Sku.first.sku_name }

        expected_data = [Sku.first.slice(:id, :onemg_sku_id, :sku_name, :manufacturer_name, 
                                         :item_group, :uom, :pack_size, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when mrp item_group_filter is applied' do
      it 'should return valid skus' do
        FactoryBot.create(:sku, item_group: 'itg1')
        FactoryBot.create(:sku, item_group: 'itg2')

        get :index, params: { item_group_filter: Sku.second.item_group }

        expected_data = [Sku.second.slice(:id, :onemg_sku_id, :sku_name, :manufacturer_name, 
                                          :item_group, :uom, :pack_size, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when pagination is applied' do
      it 'should return paginated results' do
        FactoryBot.create_list(:sku, 5)
        get :index, params: { page: 2, per_page: 1 }

        expected_data = [Sku.second.slice(:id, :onemg_sku_id, :sku_name, :manufacturer_name,
                                          :item_group, :uom, :pack_size, :created_at, :updated_at)]
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
          sku: {
            sku_name: 'Sku123',
            manufacturer_name: 'Man123',
            item_group: 'group',
            uom: 'ml',
            pack_size: 20
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sku: {
            onemg_sku_id: 1234,
            manufacturer_name: 'Man123',
            item_group: 'group',
            uom: 'ml',
            pack_size: 20
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sku: {
            onemg_sku_id: 1234,
            sku_name: 'Sku123',
            item_group: 'group',
            uom: 'ml',
            pack_size: 20
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sku: {
            onemg_sku_id: 1234,
            sku_name: 'Sku123',
            manufacturer_name: 'Man123',
            uom: 'ml',
            pack_size: 20
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sku: {
            onemg_sku_id: 1234,
            sku_name: 'Sku123',
            manufacturer_name: 'Man123',
            item_group: 'group',
            pack_size: 20
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sku: {
            onemg_sku_id: 1234,
            sku_name: 'Sku123',
            manufacturer_name: 'Man123',
            item_group: 'group',
            uom: 'ml'
          }
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          sku: {
            onemg_sku_id: nil,
            sku_name: nil,
            manufacturer_name: nil,
            item_group: nil,
            uom: nil,
            pack_size: nil
          }
        }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when parameters are valid' do
      it 'should create sku' do
        old_sku_count = Sku.count
        post :create, params: {
          sku: {
            onemg_sku_id: 1234,
            sku_name: 'Sku123',
            manufacturer_name: 'Man123',
            item_group: 'Group',
            uom: 'ml',
            pack_size: 20
          }
        }
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(Sku.last.slice(:id, :onemg_sku_id, :sku_name, :manufacturer_name, :item_group, 
                                                            :uom, :pack_size, :created_at, :updated_at).to_json).at_path('data')
        new_sku_count = Sku.count
        expect(new_sku_count - old_sku_count).to be 1
      end
    end
  end

  describe '#update' do
    context 'when parameters are not valid' do
      it 'should raise bad request' do
        put :update, params: {
          id: sku.id,
          sku: {
            onemg_sku_id: nil,
            sku_name: 'Sku123',
            manufacturer_name: 'Man123',
            item_group: 'Group',
            uom: 'ml',
            pack_size: 20
          }
        }
        expect(response).to have_http_status(:bad_request)

        put :update, params: {
          id: sku.id,
          sku: {
            onemg_sku_id: 1234,
            sku_name: nil,
            manufacturer_name: 'Man123',
            item_group: 'Group',
            uom: 'ml',
            pack_size: 20
          }
        }
        expect(response).to have_http_status(:bad_request)

        put :update, params: {
          id: sku.id,
          sku: {
            onemg_sku_id: 1234,
            sku_name: 'Sku123',
            manufacturer_name: nil,
            item_group: 'Group',
            uom: 'ml',
            pack_size: 20
          }
        }
        expect(response).to have_http_status(:bad_request)

        put :update, params: {
          id: sku.id,
          sku: {
            onemg_sku_id: 1234,
            sku_name: 'Sku123',
            manufacturer_name: 'Man123',
            item_group: nil,
            uom: 'ml',
            pack_size: 20
          }
        }
        expect(response).to have_http_status(:bad_request)

        put :update, params: {
          id: sku.id,
          sku: {
            onemg_sku_id: 1234,
            sku_name: 'Sku123',
            manufacturer_name: 'Man123',
            item_group: nil,
            uom: nil,
            pack_size: 20
          }
        }
        expect(response).to have_http_status(:bad_request)

        put :update, params: {
          id: sku.id,
          sku: {
            onemg_sku_id: 1234,
            sku_name: 'Sku123',
            manufacturer_name: 'Man123',
            item_group: nil,
            uom: 'ml',
            pack_size: nil
          }
        }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when parameters are valid' do
      it 'should update sku' do
        put :update, params: {
          id: sku.id,
          sku: {
            onemg_sku_id: 5678,
            sku_name: 'SkuABC',
            manufacturer_name: 'ManABC',
            item_group: 'Group2',
            uom: 'number',
            pack_size: 50
          }
        }
        expect(response).to have_http_status(:ok)
        expected_sku = sku.slice(:id, :onemg_sku_id, :sku_name, :manufacturer_name, 
                                 :item_group, :uom, :pack_size, :created_at, :updated_at)
        expected_sku[:onemg_sku_id] = '5678'
        expected_sku[:sku_name] = 'SkuABC'
        expected_sku[:manufacturer_name] = 'ManABC'
        expected_sku[:item_group] = 'Group2'
        expected_sku[:uom] = 'number'
        expected_sku[:pack_size] = 50
        expect(response.body).to be_json_eql(expected_sku.to_json).at_path('data')
      end
    end

    describe '#destroy' do
      context 'when id is invalid' do
        it 'should return not found' do
          delete :destroy, params: { id: 0 }
          expect(response).to have_http_status(:not_found)
        end
      end
  
      context 'when id is valid' do
        it 'should soft delete sku instance' do
          sku
          old_sku_count = Sku.count
          delete :destroy, params: { id: sku.id }
          new_sku_count = Sku.count
  
          expect(response).to have_http_status(:ok)
          expect(old_sku_count - new_sku_count).to be 1
        end
      end
    end
  end
end
