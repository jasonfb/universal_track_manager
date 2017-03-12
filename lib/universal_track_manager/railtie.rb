require 'universal_track_manager'


module DataMigrations
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'tasks/initialize.rb'
    end
  end
end