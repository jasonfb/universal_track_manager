UniversalTrackManager.configure do |config|
  config.track_ips = true
  config.track_utms = true
  config.track_user_agent = true

  # add array of symbols (parameters) to DETECT (for example config.detect_params = [:gclid, :fbclid] )
  # these parameters will not be traked but will be deteceted (present or absent)
  # you must have cooresponding *_present field (booleans) on your campaigns table
  config.detect_params = [ ]
  #GENERATOR INSERTS CAMPAIGN COLUMN CONFIG HERE

  # config.track_referrer = false

end
