$LOAD_PATH.unshift __dir__

def require_all(path)
  pattern = File.join(__dir__, path, "*.rb")
  Dir.glob(pattern).sort.each do |f|
    require f
  end
end


# require_all("generators/templates")

require_all("generators/universal_track_manager")
require_all("tasks")
require_all("universal_track_manager/controllers/concerns")
require_all("universal_track_manager/models")

module UniversalTrackManager
  require "railtie.rb" if defined?(Rails)
end


