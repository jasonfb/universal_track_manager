
require 'rails/generators'

module UniversalTrackManager
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc "Creates a UTM initializer and copy locale files to your application."

    source_root File.expand_path('../templates', __dir__)

    class_option :orm, type: 'boolean'

    class_option :param_list, type: :string, default: nil # DEPRECATED --- DO NOT USE



    class_option :add, type: :string, default: nil
    class_option :only, type: :string, default: nil


    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    desc "Creates an initializer for Universal Track Manager and copy files to your application."
    def create_universal_track_manager_migration
      # guard against pre-0.7.3 sytnax
      if options['param_list']
        puts "Oops (FATAL): param_list is removed; use 'add' to augment the default list of fields or use 'only' to replace it"
        exit
      end

      # guard against using both 'add' and 'only'
      if options['add'] && options['only']
        puts "Oops (FATAL): You specified both 'add' and 'only'; use 'add' to augment the default list of fields OR use 'only' to replace it"
        exit
      end

      @default_params = %w{utm_source utm_medium utm_campaign utm_content utm_term}

      if options['add']
        options['add'].split(",").each  do |p|
          if !@default_params.include?(p)
            @default_params << p
          end
        end
      end


      if options['only']
        @default_params = []
        options['only'].split(",").each  do |p|
          @default_params << p
        end
      end

      column_defs = ""
      @default_params.each  do |p|
        column_defs += "          t.string :#{p}, limit:256\n"
      end
      copy_file "create_universal_track_manager_tables.rb", "#{self.class.source_root}/create_universal_track_manager_tables.rb-staged"
      gsub_file "#{self.class.source_root}/create_universal_track_manager_tables.rb-staged", "#GENERATOR INSERTS CAMPAIGN COLUMNS HERE", column_defs
      migration_template "create_universal_track_manager_tables.rb-staged",  "db/migrate/create_universal_track_manager_tables.rb"

      remove_file "#{self.class.source_root}/create_universal_track_manager_tables.rb-staged"
    end

    def create_universal_track_manager_initializer
      column_config = "config.campaign_columns = '#{options.param_list}'"
      copy_file "universal_track_manager.rb", "#{self.class.source_root}/universal_track_manager.rb-staged"
      gsub_file "#{self.class.source_root}/universal_track_manager.rb-staged", "#GENERATOR INSERTS CAMPAIGN COLUMN CONFIG HERE", column_config
      copy_file 'universal_track_manager.rb-staged', 'config/initializers/universal_track_manager.rb'
      remove_file "#{self.class.source_root}/universal_track_manager.rb-staged"
    end

    def migration_version
      "[#{ActiveRecord::Migration.current_version}]" if ActiveRecord::Migration.respond_to?(:current_version)
    end
  end
end


