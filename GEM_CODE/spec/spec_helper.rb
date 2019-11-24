ENV["RAILS_ENV"] ||= "test"
begin
  require 'byebug'
rescue LoadError
end

# require rails first
require "rails/all"

# require the gem's core code
Dir["./lib/universal_track_manager/**/*.rb", "./lib/railtie.rb"].each do |x|
  require(x)
end


require "dummy/application"

require "rspec/rails"
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Dummy::Application.initialize!

RSpec.configure do |config|

  config.infer_spec_type_from_file_location!
  config.order = :random
  config.use_transactional_fixtures = true

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  config.before { restore_default_warning_free_config }

  require 'rails-controller-testing'
  config.include Rails::Controller::Testing::TestProcess
  config.include Rails::Controller::Testing::TemplateAssertions
  config.include Rails::Controller::Testing::Integration
end


def restore_default_warning_free_config

end