module UniversalTrackManager
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'tasks/install.rb'
    end
  end
end