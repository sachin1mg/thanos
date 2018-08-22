require 'sidekiq/testing'

RSpec.configure do |config|
  config.before(:each, sidekiq: true) do
    Sidekiq::Worker.clear_all
  end
end
