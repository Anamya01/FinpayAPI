require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'database_cleaner/active_record'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]

  # IMPORTANT: Disable transactional fixtures for Apartment/Multi-tenancy
  config.use_transactional_fixtures = false

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    # Clean the database once before the suite starts
    DatabaseCleaner.clean_with(:truncation)
    # Create the test tenant schema once for the suite
    Apartment::Tenant.drop('test') rescue nil
    Apartment::Tenant.create('test')
  end

  config.before(:each) do
    # Default cleaning strategy
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :request) do
    # Request specs need truncation because they switch schemas
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    # 1. Reset to public to ensure Company is created in the right place
    Apartment::Tenant.switch!('public')

    # 2. Setup the Company in public schema (since it's excluded)
    @company = Company.find_or_create_by!(subdomain: 'test', name: 'Test Corp')

    # 3. Set the host so Middleware finds the 'test' subdomain
    host! "test.lvh.me"

    # 4. Switch the test process to the 'test' schema for User.count etc.
    Apartment::Tenant.switch!('test')
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Apartment::Tenant.switch!('public')
  end

  config.filter_rails_from_backtrace!
end
