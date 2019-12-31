# note this file must be named identically to the gem's name (using hyphen)
# for it to be picked up in the Gem build
#
# THIS FILE IS NOT in the specs and is for the gem builder

$LOAD_PATH.unshift __dir__

def require_all(path)
  pattern = File.join(__dir__, path, "*.rb")
  Dir.glob(pattern).sort.each do |f|
    require f
  end
end

# require_all("generators/templates")
require_all("generators/universal_track_manager")
require_all("universal_track_manager/controllers/concerns")
require_all("universal_track_manager/models")

require("universal_track_manager")