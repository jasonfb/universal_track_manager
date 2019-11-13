

namespace :universal_track_manager do
  task :install => :environment do
    puts "createig database migrations..."
    
    generator = UniversalTrackManager::InstallGenerator.new
    generator.copy_initializer
    
    puts "creating config file..."
    
    File.open("#{Rails.root}/config/initializers/universal_track_manager.rb", 'w') { |file| file.write("UniversalTrackManager.config({ })") }
  end

end
