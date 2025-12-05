# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'capybara/rspec'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'shoulda/matchers'
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]
  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!
  # Deviseのテストヘルパーを読み込む
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Devise::Test::IntegrationHelpers, type: :request
  # ルーティングヘルパーを読み込む
  config.include Rails.application.routes.url_helpers
  config.include FactoryBot::Syntax::Methods
  config.include Warden::Test::Helpers
  # Wardenのテストモードを有効化
  Warden.test_mode!
  config.after(:each) { Warden.test_reset! }
  config.include OmniauthMacros
end
