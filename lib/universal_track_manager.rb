# primary module for UTM. note this file is included in the specs

module UniversalTrackManager
  require "railtie.rb" if defined?(Rails)

  class Settings
    attr_accessor :track_ips, :track_utms, :track_user_agent, :track_http_referrer, :campaign_columns
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

  def self.track_http_referrer?
    @_settings.track_http_referrer
  end

  def self.campaign_column_names
    @campaign_column_names ||= @_settings.campaign_columns.split(',')
  end

    def self.campaign_column_symbols
    @campaign_column_symbols ||= @_settings.campaign_columns.split(',').map{|c| c.to_sym}
  end

end


