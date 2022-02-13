
require 'rails/generators'

module UniversalTrackManager
  class AddGclidPresentGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    desc "Add gclid_present (boolean) to `campaigns` table"
    source_root File.expand_path('../templates', __dir__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    desc "Add gclid_present (boolean) to `campaigns` table"
    def create_gclid_present_migration
      migration_template "add_gclid_present_to_campaigns.rb",  "db/migrate/add_gclid_present_to_campaigns.rb"

      puts 'IMPORTANT: Be sure to add `gclid_detect` setting (true) in `config/universal_track_manager.rb`'
      puts "example config/universal_track_manager.rb file \n"
      puts "UniversalTrackManager.configure do |config|
  // other configs here ...
  config.gclid_detect = true
end"

    end

    def migration_version
      "[#{ActiveRecord::Migration.current_version}]" if ActiveRecord::Migration.respond_to?(:current_version)
    end
  end
end


