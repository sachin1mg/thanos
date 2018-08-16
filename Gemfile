source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.4'
# Use postgresql as the database for Active Record
gem 'pg',     '0.18'
# Use Puma as the app server
gem 'puma',   '3.7'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'database_cleaner', '~> 1.6', '>= 1.6.2' # Strategies for cleaning databases. Can be used to ensure a clean state for testing.
  gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2' # factory_bot_rails provides integration between factory_bot and rails
  gem 'faker', '~> 1.8', '>= 1.8.7' # Faker, a port of Data::Faker from Perl, is used to easily generate fake data: names, addresses, phone numbers, etc.
  gem 'rspec-rails', '~> 3.7' # BDD for Ruby
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'brakeman', '~> 4.2', require: false # Brakeman detects security vulnerabilities in Ruby on Rails applications via static analysis.
  gem 'bullet', '~> 5.7', '>= 5.7.5' # help to kill N+1 queries and unused eager loading.
  gem 'awesome_print'
end

group :test do
  gem 'json_spec', '~> 1.1', '>= 1.1.5' # RSpec matchers for testing JSON content
  gem 'simplecov', '~> 0.15.1', require: false # Code coverage for Ruby 1.9+ with a powerful configuration library and automatic merging of coverage across test suites
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'active_model_serializers', '~> 0.10.7' # ActiveModel::Serializers allows you to generate your JSON in an object-oriented and convention-driven manner.
gem 'activerecord-import', '~> 0.25.0' # A library for bulk inserting data using ActiveRecord.
gem 'config', '~> 1.7' # Easiest way to manage multi-environment settings
gem 'ddtrace', '~> 0.11.4', '>= 0.11.4' # Tracking the application metrics in datadog
gem 'devise', '~> 4.4', '>= 4.4.1' # Flexible authentication solution for Rails with Warden
gem 'jwt', '~> 1.5', '>= 1.5.4' # A pure ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
gem 'kaminari', '~> 1.1', '>= 1.1.1' # Kaminari is a Scope & Engine based, clean, powerful, agnostic, customizable and sophisticated paginator.
gem 'lograge', '~> 0.9.0' # Tame Rails' multi-line logging into a single line per request
gem 'logstash-event', '~> 1.2', '>= 1.2.02' # Library that contains the classes required to create LogStash events
gem 'newrelic_rpm', '~> 4.8', '>= 4.8.0.341' # Tracking the application metrics in new relic
gem 'paper_trail', '~> 8.1', '>= 8.1.2' # Track changes to your models, for auditing or versioning.
gem 'paperclip', '~> 6.0' # Easy upload management for ActiveRecord
gem 'paranoia', '~> 2.4' # Paranoia is a re-implementation of acts_as_paranoid. when you called destroy on an Active Record object that it didn't actually destroy it, but just "hid" the record.
gem 'rails_param', '~> 0.10.0' # Parameter Validation and Type Coercion for Rails
gem 'redis', '~> 4.0', '>= 4.0.1' # A Ruby client that tries to match Redis' API one-to-one, while still providing an idiomatic interface.
gem 'redis-namespace', '~> 1.6' # Adds a Redis::Namespace class which can be used to namespace calls to Redis
gem 'rest-client', '~> 2.0', '>= 2.0.2' # A simple HTTP and REST client for Ruby, inspired by the Sinatra microframework style of specifying actions: get, put, post, delete.
gem 'sentry-raven', '~> 2.7', '>= 2.7.2' # A gem that provides a client interface for the Sentry error logger
gem 'sidekiq', '~> 5.1', '>= 5.1.1' # Simple, efficient background processing for Ruby.
gem 'sidekiq-limit_fetch', '~> 3.4' # Sidekiq strategy to restrict number of workers which are able to run specified queues simultaneously.
gem 'sidekiq-logstash', '~> 0.3.0' # Sidekiq::Logstash turns your Sidekiq log into an organised, aggregated, JSON-syntax log ready to be sent to a logstash server.
gem 'sidekiq-reliable-fetch', github: 'rohitjangid/sidekiq-reliable-fetch', branch: 'refactor/sidekiq-version' # Redis reliable queue pattern implemented in Sidekiq
