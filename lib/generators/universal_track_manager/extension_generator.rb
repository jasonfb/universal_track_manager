
require 'rails/generators'

module UniversalTrackManager
  class ExtensionGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    desc "Add gclid_present (boolean) to `campaigns` table"
    source_root File.expand_path('../templates', __dir__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    desc "Add gclid_present (boolean) to `campaigns` table"
    def add_glcid_present
      migration_template "add_gclid_present_to_campaigns.rb",  "db/migrate/add_gclid_present_to_campaigns.rb"

      puts 'IMPORTANT: Be sure to add `glclid_present` to the end of the `config.campaign_columns` setting in `config/universal_track_manager.rb` (append to any existing using a comma)'
      puts "example config/universal_track_manager.rb file \n"
      puts "UniversalTrackManager.configure do |config|
  config.track_ips = true
  config.track_utms = true
  config.track_user_agent = true
  config.campaign_columns = 'utm_source,utm_medium,utm_campaign,utm_content,utm_term,gclid_present'
end"

    end

    def migration_version
      "[#{ActiveRecord::Migration.current_version}]" if ActiveRecord::Migration.respond_to?(:current_version)
    end
  end
end


