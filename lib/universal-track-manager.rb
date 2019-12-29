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

module UniversalTrackManager
  require "railtie.rb" if defined?(Rails)

  class Settings
    attr_accessor :track_ips, :track_utms, :track_user_agent, :track_referrer
  end

  def self.configure(&block)
    @_settings =  Settings.new

    block.call(@_settings)
  end


  def self.track_ips?
    @_settings.track_ips
  end

  def self.track_utms?
    @_settings.track_utms
  end

  def self.track_user_agent?
    @_settings.track_user_agent
  end

  def self.track_http_referrer
    @_settings.http_referrer
  end
end


