require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'


module UniversalTrackManager
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path("../templates", __FILE__)

    desc "Creates an initializer for Universal Track Manager and copy files to your application."
    class_option :orm, type: 'boolean'

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def copy_initializer
      migration_template "create_track_table.rb",
                         "db/migrate/create_track_table.rb"
    end
  end
end
