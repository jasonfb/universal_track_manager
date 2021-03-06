ENV["RAILS_ENV"] ||= "test"
begin
  require 'byebug'
rescue LoadError
end

if( ENV['COVERAGE'] == 'on' )
  require 'simplecov'
  require 'simplecov-rcov'
  class SimpleCov::Formatter::MergedFormatter
    def format(result)
      SimpleCov::Formatter::HTMLFormatter.new.format(result)
      SimpleCov::Formatter::RcovFormatter.new.format(result)
    end
  end
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
  SimpleCov.start 'rails' do
    add_filter "/vendor/"
    add_filter "/test/"
  end
end

# require rails first
require "rails/all"

# require the gem's core code
Dir["./lib/universal_track_manager/**/*.rb", "./lib/universal_track_manager.rb", "./lib/railtie.rb"].each do |x|
  require(x)
end


require "dummy/application"

require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Dummy::Application.initialize!

# default configs for universal track manager
UniversalTrackManager.configure do |config|
  config.track_ips = true
  config.track_utms = true
  config.track_user_agent = true
  config.campaign_columns = 'utm_source,utm_campaign,utm_medium,utm_content,utm_term'
end

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



  config.before {
    # note that because the object persist in memory accross test runs
    # (unlike database transactions), it must be reset for each
    # test run in order for the tests that disable any given feature
    # not to affect the tests after them
    # any testing for disabled should be done in-test, after this hook has run
    #
    UniversalTrackManager.configure do |config|
      config.track_ips = true
      config.track_utms = true
      config.track_http_referrer = true
      config.track_user_agent = true
      config.campaign_columns = 'utm_source,utm_campaign,utm_medium,utm_content,utm_term'
    end

    restore_default_warning_free_config
  }

  require 'rails-controller-testing'
  config.include Rails::Controller::Testing::TestProcess
  config.include Rails::Controller::Testing::TemplateAssertions
  config.include Rails::Controller::Testing::Integration
end




def restore_default_warning_free_config

end
