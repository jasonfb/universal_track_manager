

["generators/**/*.rb", "universal_track_manager/**/*.rb"].each do |x|
  Dir.glob(File.join(File.dirname(__FILE__), x)) do |c|
    require(c) 
  end
  
end

module UniversalTrackManager
  require "railtie.rb" if defined?(Rails)
end


