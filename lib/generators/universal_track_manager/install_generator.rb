require 'rails/generators/active_record'

module UniversalTrackManager
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc "Creates a UTM initializer and copy locale files to your application."

    source_root File.expand_path('../templates', __dir__)

    class_option :orm, type: 'boolean'


    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    desc "Creates an initializer for Universal Track Manager and copy files to your application."
    def create_universal_track_manager_migration
      migration_template "create_universal_track_manager_tables.rb",  "db/migrate/create_universal_track_manager_tables.rb"
    end

    def create_universal_track_manager_initializer
      copy_file 'universal_track_manager.rb', 'config/initializers/universal_track_manager.rb'
    end

    def migration_version
      "[#{ActiveRecord::Migration.current_version}]" if ActiveRecord::Migration.respond_to?(:current_version)
    end
  end
end


