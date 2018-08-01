# RSpec.describe Api::Internal::V1::VendorsController, type: :controller, skip_auth: true do
#   let(:vendor) { FactoryBot.create(:vendor, :active) }

#   describe '#show' do
#     it 'should check valid id' do
#       get :show, params: { id: 0 }
#       expect(response).to have_http_status(:not_found)
#     end

#     context 'GET /vendor/:id' do
#       it 'should return vendor instance' do
#         get :show, params: { id: vendor.id }

#         expect(response).to have_http_status(:ok)
#         expected_data = vendor.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                      :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                      :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                      :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
#       end
#     end

#     context 'GET /vendor/:id?fields=id,code,leaves' do
#       it 'should return vendor instance with given fields' do
#         get :show, params: {
#           id: vendor.id,
#           fields: 'id,code,leaves'
#         }

#         expect(response).to have_http_status(:ok)
#         expected_data = vendor.slice(:id, :code, :leaves)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
#       end
#     end

#     context 'GET /vendor/:id?include=address_detail,vendor_commissions' do
#       it 'should return vendor instance with included fields' do
#         get :show, params: {
#           id: vendor.id,
#           include: 'address_detail,vendor_commissions'
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response_body['data']['id']).to eq(vendor.id)
#         expect(response_body['data']['address_detail']['id']).not_to be_nil
#         expect(response_body['data']['vendor_commissions']).to be_an_instance_of(Array)
#       end
#     end
#   end

#   describe '#index' do
#     before(:each) do
#       FactoryBot.create_list(:vendor, 2, :active, serviceable_pincodes: ['122001', '122002'])
#       FactoryBot.create_list(:vendor, 2, :active, serviceable_pincodes: ['122002'])
#       FactoryBot.create_list(:vendor, 2, :active, serviceable_pincodes: ['122003'])
#       FactoryBot.create_list(:vendor, 4, :active, serviceable_pincodes: [])
#       FactoryBot.create_list(:vendor, 2, :inactive, serviceable_pincodes: ['122001', '122002'])
#       FactoryBot.create_list(:vendor, 2, :inactive, serviceable_pincodes: ['122002'])
#       FactoryBot.create_list(:vendor, 2, :inactive, serviceable_pincodes: ['122003'])
#       FactoryBot.create_list(:vendor, 4, :inactive, serviceable_pincodes: [])
#     end

#     context 'Fields are passed' do
#       it 'should return requested fields' do
#         skip
#       end
#       it 'should skip invalid fields' do
#         skip
#       end
#     end

#     context "GET /vendors?page=1&per_page=5&fields='id,code,active,tags'" do
#       it 'should return paginated vendors with given fields' do
#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code,active,tags'
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(5).at_path('data')
#         expected_data = Vendor.order(:id).first.slice(:id,:code,:active,:tags)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors?page=1&per_page=5&fields='id,code,active,tags'&active=true" do
#       it 'should return paginated active vendors with given fields' do
#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code,active,tags',
#           active: true
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size([Vendor.active.count, 5].min).at_path('data')
#         expected_data = Vendor.active.order(:id).first.slice(:id,:code,:active,:tags)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors?page=1&per_page=5&sort_by=name:asc" do
#       it 'should return paginated vendors ordered by name' do
#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           sort_by: 'name:asc'
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size([Vendor.count, 5].min).at_path('data')
#         expected_data = Vendor.order(:name).first.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                                          :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                                          :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                                          :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors?page=1&per_page=5&fields='id,code,tags'&city=gurgaon" do
#       it 'should return paginated filtered vendors' do
#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code,tags',
#           city: 'gurgaon'
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size([Vendor.count, 5].min).at_path('data')
#         expected_data = Vendor.order(:id).first.slice(:id,:code,:tags)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors?page=1&per_page=5&fields='id,code,tags'&state=haryana" do
#       it 'should return paginated filtered vendors' do
#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code,tags',
#           state: 'haryana'
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size([Vendor.count, 5].min).at_path('data')
#         expected_data = Vendor.order(:id).first.slice(:id,:code,:tags)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors?email=some@email.com" do
#       it 'should return paginated filtered vendors' do
#         vendor = Vendor.first
#         email = vendor.emails.first
#         vendors = Vendor.with_email(email).order(:id)

#         get :index, params: {
#           email: email
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size([vendors.count, Vendor.default_per_page].min).at_path('data')
#         expected_data = vendors.first.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                              :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                              :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                              :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors?page=1&per_page=5&fields=id,code,tags&city=gurgaon&active=true" do
#       it 'should return paginated active vendors of gurgaon' do
#         vendors = Vendor.active.order(:id)

#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code,tags',
#           city: 'gurgaon',
#           active: true
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size([vendors.count, 5].min).at_path('data')
#         expected_data = vendors.first.slice(:id, :code, :tags)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors?page=1&per_pages=5&service_pincodes[]=123456" do
#       it 'should return paginated vendors of serviceable pincodes' do
#         pincode = vendor.serviceable_pincodes.first
#         vendors = Vendor.with_serviceable_pincode(pincode).order(:id)
#         MatviewServiceablePincode.refresh

#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           service_pincodes: [pincode]
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size([vendors.count, 5].min).at_path('data')
#         expected_data = vendors.first.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                              :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                              :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                              :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors?page=1&per_pages=5&fields=id,code&serviceable_pincode=123456&available_at=1527678141" do
#       it 'should return paginated vendors of serviceable pincode and available at given time' do
#         vendor = FactoryBot.create(:vendor, :with_leaves)
#         serviceable_pincode = vendor.serviceable_pincodes.first
#         leave_id = vendor.leaves.keys.first
#         leave_time = vendor.leaves[leave_id]['start_time']
#         # leave_duration = vendor.leaves[leave_id]['duration']

#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code',
#           serviceable_pincode: serviceable_pincode,
#           available_at: (Time.at(leave_time) - 1.day).to_i,
#           id: vendor.id # adding id to ensure return of result
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(1).at_path('data')
#         expected_data = vendor.slice(:id, :code)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')

#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code',
#           serviceable_pincode: serviceable_pincode,
#           available_at: (Time.at(leave_time) + 10.seconds).to_i,
#           id: vendor.id # adding id to ensure return of result
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(0).at_path('data')
#       end
#     end

#     context "GET /vendors?page=1&per_pages=5&fields=id,code,tags&active=true&all_service_pincode_in[]=123456" do
#       it 'should return paginated vendors with all serviceable pincode in given pincodes' do
#         pincodes = vendor.serviceable_pincodes

#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code,tags',
#           all_service_pincode_in: pincodes,
#           id: vendor.id # adding id to ensure return of result
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(1).at_path('data')
#         expected_data = vendor.slice(:id, :code, :tags)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors?page=1&per_pages=5&fields=id,code&active=true&city=gurgaon&available_at=1527678141" do
#       it 'should return paginated vendors with all serviceable pincode in given pincodes' do
#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code',
#           city: 'Gurgaon',
#           active: true,
#           available_at: Time.now.to_i
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(5).at_path('data')
#         expected_data = Vendor.active.order(:id).first.slice(:id, :code)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors?page=1&per_pages=5&fields=id,code&ids[]=1" do
#       it 'should return paginated vendors of given ids' do
#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code',
#           ids: [vendor.id]
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(1).at_path('data')
#         expected_data = vendor.slice(:id, :code)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors?page=1&per_pages=5&active=true" do
#       it 'should return paginated active vendors' do
#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           active: true
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(5).at_path('data')
#         expected_data = Vendor.active.order(:id).first.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                                              :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                                              :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                                              :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors?fields=id,code,leaves&code=:code" do
#       it 'should return paginated vendors with given code' do
#         get :index, params: {
#           fields: 'id,code,leaves',
#           code: vendor.code
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(1).at_path('data')
#         expected_data = vendor.slice(:id, :code, :leaves)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end

#       it 'should return paginated vendors with given code' do
#         get :index, params: {
#           fields: 'id,code,leaves',
#           code: 'INVALID_CODE'
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(0).at_path('data')
#         expected_data = []
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
#       end
#     end

#     context "GET /vendors?id=:id&active=true" do
#       it 'should return vendor of given id with active filter' do
#         get :index, params: {
#           id: vendor.id,
#           active: true
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(1).at_path('data')
#         expected_data = vendor.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                      :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                      :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                      :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')

#         get :index, params: {
#           id: vendor.id,
#           active: false
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(0).at_path('data')
#       end
#     end

#     context "GET /vendors?page=1&per_page=5&fields=id,code,tags&not_serviceable_in[]=123456" do
#       it 'should raise error when invalid pincode present in pincodes array' do
#         get :index, params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code,tags',
#           not_serviceable_in: ['123z']
#         }
#         expect(response).to have_http_status(:bad_request)
#       end

#       it "should return vendors which are not serviceable on any of given pincode" do
#         get :index,  params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code,tags',
#           not_serviceable_in: ['122002']
#         }
#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(4).at_path('data')

#         get :index,  params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,code,tags',
#           not_serviceable_in: ['122002', '122003']
#         }
#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size(0).at_path('data')
#       end
#     end
#   end

#   describe '#with_address' do
#     before(:each) do
#       FactoryBot.create_list(:vendor, 10, :active)
#     end
#     context "GET /vendors/with_address?page=1&per_page=5&fields='id,name,city'&query=:query" do
#       it 'should return paginated filtered vendors' do
#         vendor = Vendor.first
#         vendors = Vendor.where("name like ?", "%#{vendor.name}%").order(:id)

#         get :index_with_address, params: {
#           page: 1,
#           per_page: 5,
#           fields: 'id,name,city',
#           query: vendor.name
#         }

#         expect(response).to have_http_status(:ok)
#         expect(response.body).to have_json_size([vendors.count, 5].min).at_path('data')
#         expected_data = vendor.slice(:id, :name, :address).merge(city: 'Gurgaon')
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end
#   end

#   describe '#address_coordinates' do
#     context "POST /vendors/address_coordinates" do
#       it 'should have ids params as required' do
#         get :address_coordinates, params: {}

#         expect(response).to have_http_status(:bad_request)
#       end

#       it 'should return address_coordinates location per vendor id' do
#         get :address_coordinates, params: {
#           ids: [vendor.id]
#         }

#         expect(response).to have_http_status(:ok)
#         expected_data = {
#           vendor.id => [28, 77]
#         }
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
#       end
#     end
#   end

#   describe '#by_email' do
#     context "GET /vendors/email/some@email.com?active=true" do
#       it 'should return active vendors with given email' do
#         get :by_email, params: {
#           email: vendor.emails.first,
#           active: true
#         }

#         expect(response).to have_http_status(:ok)
#         expected_data = vendor.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                      :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                      :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                      :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end

#       it 'should return active vendors with given email and only given fields' do
#         get :by_email, params: {
#           email: vendor.emails.first,
#           active: true,
#           fields: 'id,code,name,emails'
#         }

#         expect(response).to have_http_status(:ok)
#         expected_data = vendor.slice(:id, :code, :name, :emails)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data/0')
#       end
#     end

#     context "GET /vendors/email/some@email.com?active=true&unique=true" do
#       let(:vendors) { FactoryBot.create_list(:vendor, 2, emails: ['test@gmail.com']) }

#       it 'should return active vendor with given email' do
#         expect(Sentry).to receive(:info)

#         get :by_email, params: {
#           email: vendors.first.emails.first,
#           active: true,
#           unique: true
#         }

#         expect(response).to have_http_status(:ok)
#         expected_data = vendors.first.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                      :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                      :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                      :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
#       end
#     end
#   end

#   describe '#create' do
#     context "POST /vendors" do
#       it 'should check for required params' do
#         post :create
#         expect(response).to have_http_status(:bad_request)

#         post :create, params: {
#           name: 'random',
#           active: true
#         }
#         expect(response).to have_http_status(:bad_request)

#         post :create, params: {
#           code: 'random',
#           active: true
#         }
#         expect(response).to have_http_status(:bad_request)
#       end

#       it 'should validate params' do
#         post :create, params: {
#             name: 'random',
#             code: 'random',
#             min_order_amount: '213d'
#         }
#         expect(response).to have_http_status(:bad_request)

#         post :create, params: {
#             code: 'random',
#             opening_time: '134g'
#         }
#         expect(response).to have_http_status(:bad_request)
#       end

#       it 'should validate serviceable_pincodes as superset of direct_to_vendor_pincodes' do
#         post :create, params: {
#           name: 'Random Name',
#           code: 'random',
#           active: true,
#           address: {
#             name: '1mg',
#             pincode: '122001',
#             state: 'Haryana',
#             street1:  'Motorola Building',
#             street2: '',
#             city: 'Gurgaon',
#             country: 'IN',
#           },
#           serviceable_pincodes: ['121212'],
#           direct_to_vendor_pincodes: ['121212', '120101']
#         }
#         expect(response).to have_http_status(:unprocessable_entity)
#       end

#       it 'should set default values' do
#         post :create, params: {
#           name: 'Random Name',
#           code: 'random',
#           active: true,
#           address: {
#             name: '1mg',
#             pincode: '122001',
#             state: 'Haryana',
#             street1:  'Motorola Building',
#             street2: '',
#             city: 'Gurgaon',
#             country: 'IN',
#           },
#           serviceable_pincodes: ['121212'],
#           direct_to_vendor_pincodes: ['121212']
#         }
#         expect(response).to have_http_status(:ok)
#         expected_data = Vendor.last.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                            :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                            :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                            :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expected_data['address_detail'] = AddressServiceStub.address
#         expect(response_body['data']['min_order_amount']).to eq(150)
#         expect(response_body['data']['mrp_difference_limit']).to eq(500)
#       end

#       it 'should create vendor and address on address service' do
#         old_vendor_count = Vendor.count
#         post :create, params: {
#           name: 'Random Name',
#           code: 'random',
#           active: true,
#           serviceable_pincodes: ['121212'],
#           direct_to_vendor_pincodes: ['121212'],
#           address: {
#             name: '1mg',
#             pincode: '122001',
#             state: 'Haryana',
#             street1:  'Motorola Building',
#             street2: '',
#             city: 'Gurgaon',
#             country: 'IN'
#           }
#         }
#         expect(response).to have_http_status(:ok)
#         expected_data = Vendor.last.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                            :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                            :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                            :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expected_data['vendor_commissions'] = []
#         expected_data['address_detail'] = AddressServiceStub.address
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
#         expect(response_body['data']['address']).not_to be nil
#         new_vendor_count = Vendor.count
#         expect(new_vendor_count - old_vendor_count).to be 1
#         # expect_any_instance_of(Api::AddressService::Address).to receive(:create)
#       end

#       it 'should create vendor commission' do
#         post :create, params: {
#           name: 'Random Name',
#           code: 'random',
#           active: true,
#           address: {
#             name: '1mg',
#             pincode: '122001',
#             state: 'Haryana',
#             street1:  'Motorola Building',
#             street2: '',
#             city: 'Gurgaon',
#             country: 'IN',
#           },
#           vendor_commissions: [
#             { sku_type: 'rx', commission: 10 },
#             { sku_type: 'patanjali', commission: 10 }
#           ]
#         }
#         expect(response).to have_http_status(:ok)

#         expected_data = Vendor.last.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                            :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                            :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                            :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expected_data['address_detail'] = AddressServiceStub.address
#         expected_data['vendor_commissions'] = Vendor.last.vendor_commissions.map { |vendor_commission| vendor_commission.slice(:created, :sku_type, :commission, :vendor_id, :updated) }
#         expected_data['vendor_commissions'] = expected_data['vendor_commissions'].each do |vendor_commission|
#           vendor_commission['created'] = vendor_commission['created'].to_i
#           vendor_commission['updated'] = vendor_commission['updated'].to_i
#         end

#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
#       end
#     end
#   end

#   describe '#update' do
#     context "PUT /vendors" do
#       before(:each) do
#         vendor
#       end

#       it 'should check for required params' do
#         put :update, params: { id: vendor.id }
#         expect(response).to have_http_status(:bad_request)

#         put :update, params: {
#           id: vendor.id
#         }
#         expect(response).to have_http_status(:bad_request)

#         put :update, params: {
#           id: vendor.id,
#           name: 'random',
#           active: true
#         }
#         expect(response).to have_http_status(:bad_request)

#         put :update, params: {
#           id: vendor.id,
#           code: 'random',
#           active: true
#         }
#         expect(response).to have_http_status(:bad_request)
#       end

#       it 'should validate params' do
#         put :update, params: {
#           id: vendor.id,
#           name: 'random',
#           code: 'random',
#           min_order_amount: '213d'
#         }
#         expect(response).to have_http_status(:bad_request)

#         put :update, params: {
#           id: vendor.id,
#           code: 'random',
#           opening_time: '134g'
#         }
#         expect(response).to have_http_status(:bad_request)
#       end

#       it 'should validate serviceable_pincodes as superset of direct_to_vendor_pincodes' do
#         put :update, params: {
#           id: vendor.id,
#           name: 'Random Name',
#           code: 'random',
#           active: true,
#           serviceable_pincodes: ['121212'],
#           direct_to_vendor_pincodes: ['121212', '120101'],
#           address: {
#             name: '1mg',
#             pincode: '122001',
#             state: 'Haryana',
#             street1:  'Motorola Building',
#             street2: '',
#             city: 'Gurgaon',
#             country: 'IN',
#           }
#         }
#         expect(response).to have_http_status(:unprocessable_entity)
#       end

#       it 'should set default values if values not passed while update' do
#         expect(vendor.mrp_difference_limit).not_to eq(Settings.VENDOR.DEFAULTS.MRP_DIFFERENCE_LIMIT || 500)
#         put :update, params: {
#           id: vendor.id,
#           name: 'Random Name',
#           code: 'random',
#           address: {
#             name: '1mg',
#             pincode: '122001',
#             state: 'Haryana',
#             street1:  'Motorola Building',
#             street2: '',
#             city: 'Gurgaon',
#             country: 'IN',
#           }
#         }
#         expect(response).to have_http_status(:ok)
#         expected_data = vendor.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                      :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                      :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                      :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expected_data['address_detail'] = AddressServiceStub.address
#         expect(response_body['data']['mrp_difference_limit']).to eq(Settings.VENDOR.DEFAULTS.MRP_DIFFERENCE_LIMIT || 500)
#         expect(response_body['data']['categories']).to eq []
#       end

#       it 'should update vendor attributes' do
#         put :update, params: {
#           id: vendor.id,
#           name: 'Random Name',
#           code: 'random',
#           active: true,
#           serviceable_pincodes: ['121212'],
#           direct_to_vendor_pincodes: ['121212'],
#           address: {
#             name: '1mg',
#             pincode: '122001',
#             state: 'Haryana',
#             street1:  'Motorola Building',
#             street2: '',
#             city: 'Gurgaon',
#             country: 'IN',
#           }
#         }
#         expect(response).to have_http_status(:ok)
#         expected_data = vendor.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                      :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                      :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                      :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expected_data['categories'] = []
#         expected_data['name'] = 'Random Name'
#         expected_data['code'] = 'random'
#         expected_data['mrp_difference_limit'] = 500.0
#         expected_data['address_detail'] = AddressServiceStub.address
#         # expected_data['serviceable_pincodes'] = ['121212']
#         # expected_data['direct_to_vendor_pincodes'] = ['121212']
#         expected_data['vendor_commissions'] = []
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
#       end

#       it 'should update vendor commission' do
#         post :create, params: {
#           name: 'Random Name',
#           code: 'random',
#           address: {
#             name: '1mg',
#             pincode: '122001',
#             state: 'Haryana',
#             street1:  'Motorola Building',
#             street2: '',
#             city: 'Gurgaon',
#             country: 'IN',
#           },
#           vendor_commissions: [
#             { sku_type: 'rx', commission: 10 },
#             { sku_type: 'patanjali', commission: 10 }
#           ]
#         }

#         expect(Vendor.last.vendor_commissions.first.commission).to eq 10.0

#         put :update, params: {
#           id: Vendor.last.id,
#           name: 'Random Name',
#           code: 'random',
#           active: true,
#           serviceable_pincodes: ['121212'],
#           direct_to_vendor_pincodes: ['121212'],
#           vendor_commissions: [
#             { sku_type: 'rx', commission: 20 },
#             { sku_type: 'patanjali', commission: 30 }
#           ],
#           address: {
#             name: '1mg',
#             pincode: '122001',
#             state: 'Haryana',
#             street1:  'Motorola Building',
#             street2: '',
#             city: 'Gurgaon',
#             country: 'IN',
#           }
#         }
#         expect(response).to have_http_status(:ok)
#         expected_data = Vendor.last.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                            :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                            :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                            :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expected_data['categories'] = []
#         expected_data['name'] = 'Random Name'
#         expected_data['code'] = 'random'
#         expected_data['mrp_difference_limit'] = 500.0
#         expected_data['address_detail'] = AddressServiceStub.address
#         expected_data['vendor_commissions'] = Vendor.last.vendor_commissions.map { |vendor_commission| vendor_commission.slice(:created, :sku_type, :commission, :vendor_id, :updated) }
#         expected_data['vendor_commissions'] = expected_data['vendor_commissions'].each do |vendor_commission|
#           vendor_commission['created'] = vendor_commission['created'].to_i
#           vendor_commission['updated'] = vendor_commission['updated'].to_i
#         end
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
#         expect(Vendor.last.vendor_commissions.where(sku_type: 'rx').first.commission).to eq 20.0
#         expect(Vendor.last.vendor_commissions.where(sku_type: 'patanjali').first.commission).to eq 30.0
#       end


#       it 'should update and create vendor commission when sku_type,vendor_id combination not present' do
#         post :create, params: {
#           name: 'Random Name',
#           code: 'random',
#           address: {
#             name: '1mg',
#             pincode: '122001',
#             state: 'Haryana',
#             street1:  'Motorola Building',
#             street2: '',
#             city: 'Gurgaon',
#             country: 'IN',
#           },
#           vendor_commissions: [
#             { sku_type: 'rx', commission: 10 },
#             { sku_type: 'patanjali', commission: 10 }
#           ]
#         }

#         expect(Vendor.last.vendor_commissions.first.commission).to eq 10.0
#         expect(Vendor.last.vendor_commissions.count).to eq 2

#         put :update, params: {
#           id: Vendor.last.id,
#           name: 'Random Name',
#           code: 'random',
#           active: true,
#           serviceable_pincodes: ['121212'],
#           direct_to_vendor_pincodes: ['121212'],
#           vendor_commissions: [
#             { sku_type: 'rx', commission: 20 },
#             { sku_type: 'patanjali', commission: 30 },
#             { sku_type: 'new_type', commission: 30 }
#           ],
#           address: {
#             name: '1mg',
#             pincode: '122001',
#             state: 'Haryana',
#             street1:  'Motorola Building',
#             street2: '',
#             city: 'Gurgaon',
#             country: 'IN',
#           }
#         }
#         expect(response).to have_http_status(:ok)
#         expected_data = Vendor.last.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                           :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                           :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                           :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expected_data['categories'] = []
#         expected_data['name'] = 'Random Name'
#         expected_data['code'] = 'random'
#         expected_data['mrp_difference_limit'] = 500.0
#         expected_data['address_detail'] = AddressServiceStub.address
#         expected_data['vendor_commissions'] = Vendor.last.vendor_commissions.map { |vendor_commission| vendor_commission.slice(:created, :sku_type, :commission, :vendor_id, :updated) }
#         expected_data['vendor_commissions'] = expected_data['vendor_commissions'].each do |vendor_commission|
#           vendor_commission['created'] = vendor_commission['created'].to_i
#           vendor_commission['updated'] = vendor_commission['updated'].to_i
#         end
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
#         expect(Vendor.last.vendor_commissions.where(sku_type: 'rx').first.commission).to eq 20.0
#         expect(Vendor.last.vendor_commissions.where(sku_type: 'patanjali').first.commission).to eq 30.0
#         expect(Vendor.last.vendor_commissions.count).to eq 3
#       end

#       it 'should update vendor address' do
#         put :update, params: {
#           id: vendor.id,
#           name: 'Random Name',
#           code: 'random',
#           address: {
#             name: '1mg',
#             pincode: '122001',
#             state: 'Haryana',
#             street1:  'Motorola Building',
#             street2: '',
#             city: 'Gurgaon',
#             country: 'IN',
#           },
#         }
#         expect(response).to have_http_status(:ok)
#         expected_data = Vendor.last.slice(:created, :is_tax_inclusive_required, :code, :min_order_amount, :categories,
#                                            :closing_time, :tags, :mrp_difference_limit, :updated, :active, :id,
#                                            :is_transfer_pricing_required, :direct_to_vendor, :opening_time,
#                                            :name, :address, :holiday, :leaves)
#         expected_data['created'] = expected_data['created'].to_i
#         expected_data['updated'] = expected_data['updated'].to_i
#         expected_data['categories'] = []
#         expected_data['name'] = 'Random Name'
#         expected_data['code'] = 'random'
#         expected_data['mrp_difference_limit'] = 500.0
#         expected_data['address_detail'] = AddressServiceStub.address
#         expected_data['vendor_commissions'] = Vendor.last.vendor_commissions.map { |vendor_commission| vendor_commission.slice(:created, :sku_type, :commission, :vendor_id, :updated) }
#         expected_data['vendor_commissions'] = expected_data['vendor_commissions'].each do |vendor_commission|
#           vendor_commission['created'] = vendor_commission['created'].to_i
#           vendor_commission['updated'] = vendor_commission['updated'].to_i
#         end
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
#       end
#     end
#   end

#   describe '#serviceable_pincode' do
#     before(:each) do
#       FactoryBot.create_list(:vendor, 10, :active)
#     end
#     it 'should raise error on missing pincodes' do
#       get :serviceable_pincode, params: {
#         fields: 'id'
#       }
#       expect(response).to have_http_status(:bad_request)
#     end
#     it 'should raise error on missing fields or invalid fields' do
#       get :serviceable_pincode, params: {
#         pincodes: [123456]
#       }
#       expect(response).to have_http_status(:bad_request)

#       get :serviceable_pincode, params: {
#         fields: 'id,invalid',
#         pincodes: [123456]
#       }
#       expect(response).to have_http_status(:bad_request)
#     end
#     context "GET /vendors/serviceable_pincode?fields=id&pincodes[]=123456" do
#       it 'should return vendors grouped by pincodes' do
#         pincodes = Vendor.first.serviceable_pincodes
#         MatviewServiceablePincode.refresh

#         put :serviceable_pincode, params: {
#           fields: 'id',
#           pincodes: pincodes
#         }
#         expect(response).to have_http_status(:ok)
#         expected_data = Vendor.first.slice(:id)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path("data/#{pincodes.first}/0")
#       end
#     end
#     context "GET /vendors/serviceable_pincode?fields=id,code,name&pincodes[]=123456" do
#       it 'should return vendors grouped by pincodes' do
#         pincodes = Vendor.first.serviceable_pincodes
#         MatviewServiceablePincode.refresh

#         put :serviceable_pincode, params: {
#           fields: 'id,code,name',
#           pincodes: pincodes
#         }
#         expect(response).to have_http_status(:ok)
#         expected_data = Vendor.first.slice(:id, :code, :name)
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path("data/#{pincodes.first}/0")
#       end
#     end
#   end

#   describe '#direct_to_vendor_pincodes' do
#     before(:each) do
#       FactoryBot.create(:vendor, active: false, direct_to_vendor: true, direct_to_vendor_pincodes: ['110006'])
#       FactoryBot.create(:vendor, active: true, direct_to_vendor: true, direct_to_vendor_pincodes: ['110007'])
#       FactoryBot.create(:vendor, active: true, direct_to_vendor: false, direct_to_vendor_pincodes: ['110008'])
#     end

#     context "GET /vendors/direct_to_vendor_pincodes" do
#       it 'should return all_direct_to_vendor_pincodes of active vendors' do
#         get :direct_to_vendor_pincodes
#         expect(response).to have_http_status(:ok)
#         expected_data = ['110007']
#         expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
#       end
#     end
#   end


#   describe '#discount_exist' do
#     before(:each) do
#       @vendor1 = FactoryBot.create(:vendor)
#       FactoryBot.create_list(:inventory, 10, vendor: @vendor1, vendor_discount_percent: 10 )
#       @vendor2 = FactoryBot.create(:vendor)
#       FactoryBot.create_list(:inventory, 10, vendor: @vendor2, vendor_discount_percent: nil)
#     end

#     it 'should return raise 404 when vendor not found.' do
#       get :discount_exist, params: { id: -1 }
#       expect(response).to have_http_status(:not_found)
#     end

#     it 'should return true when discount percent exist for all skus of given vendor id.' do
#       get :discount_exist, params: { id: @vendor1.id }
#       expect(response).to have_http_status(:ok)
#       expect(response_body['data']).to be true
#     end

#     it 'should return false when discount percent exist for all skus of given vendor id.' do
#       get :discount_exist, params: { id: @vendor2.id }
#       expect(response).to have_http_status(:ok)
#       expect(response_body['data']).to be false
#     end
#   end
# end


RSpec.describe Api::Public::V1::LocationsController, type: :controller, skip_auth: true do
  let(:location) { FactoryBot.create(:location, vendor: Vendor.first) }

  # describe "GET #create" do
  #   it "returns http success" do
  #     get :create
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #update" do
  #   it "returns http success" do
  #     get :update
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #destroy" do
  #   it "returns http success" do
  #     get :destroy
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #index" do
  #   it "returns http success" do
  #     get :index
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  describe '#show' do
    it 'should check valid id' do
      get :show, params: { id: 0 }
      expect(response).to have_http_status(:not_found)
    end

    context 'GET /locations/:id' do
      it 'should return location instance' do
        get :show, params: { id: location.id }

        expected_data = location.slice(:id, :vendor_id, :aisle, :rack, :slab, :bin, :created_at, :updated_at)
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
                          location.slice(:id, :vendor_id, :aisle, :rack, :slab, :bin, :created_at, :updated_at)
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

        expected_data = [Location.first.slice(:id, :vendor_id, :aisle, :rack, :slab, :bin, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when rack filter is applied' do
      it 'should return valid locations' do
        FactoryBot.create_list(:location, 2, vendor: Vendor.first)
        get :index, params: { rack: Location.second.rack }

        expected_data = [Location.second.slice(:id, :vendor_id, :aisle, :rack, :slab, :bin, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when slab filter is applied' do
      it 'should return valid locations' do
        FactoryBot.create_list(:location, 2, vendor: Vendor.first)
        get :index, params: { slab: Location.first.slab }

        expected_data = [Location.first.slice(:id, :vendor_id, :aisle, :rack, :slab, :bin, :created_at, :updated_at)]
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_json_size(expected_data.count).at_path('data')
        expect(response.body).to be_json_eql(expected_data.to_json).at_path('data')
      end
    end

    context 'when bin filter is applied' do
      it 'should return valid locations' do
        FactoryBot.create_list(:location, 2, vendor: Vendor.first)
        get :index, params: { bin: Location.second.bin }

        expected_data = [Location.second.slice(:id, :vendor_id, :aisle, :rack, :slab, :bin, :created_at, :updated_at)]
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
          ailse: 'Aisle',
          rack: 'Rack',
          slab: 'Slab'
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          ailse: 'Aisle',
          rack: 'Rack',
          bin: 'Bin'
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          ailse: 'Aisle',
          slab: 'Slab',
          bin: 'Bin'
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          rack: 'Rack',
          slab: 'Slab',
          bin: 'Bin'
        }
        expect(response).to have_http_status(:bad_request)

        post :create, params: {
          aisle: '',
          rack: '',
          slab: '',
          bin: ''
        }
        expect(response).to have_http_status(:bad_request)
      end

      it 'should create vendor and address on address service' do
        old_vendor_count = Vendor.count
        post :create, params: {
          aisle: 'Aisle',
          rack: 'Rack',
          slab: 'Slab',
          bin: 'Bin'
        }
        expect(response).to have_http_status(:ok)
        expect(response.body).to be_json_eql(Vendor.last.to_json).at_path('data')
        new_vendor_count = Vendor.count
        expect(new_vendor_count - old_vendor_count).to be 1
      end
    end
  end
end
