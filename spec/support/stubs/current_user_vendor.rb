RSpec.configure do |config|
  config.before(:each) do
    vendor = FactoryBot.create(:vendor)
    user = FactoryBot.create(:user, vendor: vendor)
    allow_any_instance_of(ApplicationController).to receive(:current_user) do
      user
    end
    allow_any_instance_of(Api::Public::BaseController).to receive(:current_vendor) do
      vendor
    end
  end
end
