RSpec.describe Api::Public::V1::PurchaseReceiptsController, type: :controller, skip_auth: true do
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
end
