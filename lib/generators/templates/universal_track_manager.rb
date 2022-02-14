UniversalTrackManager.configure do |config|
  config.track_ips = true
  config.track_utms = true
  config.track_user_agent = true
  config.detect_params = [ ] # array of symbols (parameters) to DETECT  you must have cooresponding *_present fields (booleans) on your campaigns table
  #GENERATOR INSERTS CAMPAIGN COLUMN CONFIG HERE

  # config.track_referrer = false

end
