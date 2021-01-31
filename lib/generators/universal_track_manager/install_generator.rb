
require 'rails/generators'

require 'byebug'

module UniversalTrackManager
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc "Creates a UTM initializer and copy locale files to your application."

    source_root File.expand_path('../templates', __dir__)

    class_option :orm, type: 'boolean'
    class_option :param_list, type: :string, default: 'utm_source,utm_medium,utm_campaign,utm_content,utm_term'


    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    desc "Creates an initializer for Universal Track Manager and copy files to your application."
    def create_universal_track_manager_migration
      @params = options['param_list']
      column_defs = ""
      @params.split(',').each  do |p|
        column_defs += "          t.string :#{p}, limit:256\n"
      end

      index_def = "add_index :campaigns, #{@params.split(',').map{|c| c.to_sym}.to_s}, name: 'utm_all_combined'"
      copy_file "create_universal_track_manager_tables.rb", "#{self.class.source_root}/create_universal_track_manager_tables.rb-staged"
      byebug
      gsub_file "#{self.class.source_root}/create_universal_track_manager_tables.rb-staged", "#GENERATOR INSERTS CAMPAIGN COLUMNS HERE", column_defs
      byebug
      gsub_file "#{self.class.source_root}/create_universal_track_manager_tables.rb-staged", "#GENERATOR INSERTS CAMPAIGN INDEX HERE", index_def
      migration_template "create_universal_track_manager_tables.rb-staged",  "db/migrate/create_universal_track_manager_tables.rb"
    end

    def create_universal_track_manager_initializer
      column_config = "config.campaign_columns = '#{options.param_list}'"
      copy_file "universal_track_manager.rb", "#{self.class.source_root}/universal_track_manager.rb-staged"
      gsub_file "#{self.class.source_root}/universal_track_manager.rb-staged", "#GENERATOR INSERTS CAMPAIGN COLUMN CONFIG HERE", column_config
      copy_file 'universal_track_manager.rb-staged', 'config/initializers/universal_track_manager.rb'
    end

    def migration_version
      "[#{ActiveRecord::Migration.current_version}]" if ActiveRecord::Migration.respond_to?(:current_version)
    end
  end
end


