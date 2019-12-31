
require 'spec_helper.rb'



describe UniversalTrackManager do
  context("#configure") do
    it "should be able to be configured" do
      UniversalTrackManager.configure do |config|
        config.track_ips = false
        config.track_utms = false
        config.track_user_agent = false
      end
    end

    it "should be able to turn track_ips off" do
      UniversalTrackManager.configure do |config|
        config.track_ips = false
      end
      expect(UniversalTrackManager.track_ips?).to be(false)
    end

    it "should be able to turn track_utms off" do
      UniversalTrackManager.configure do |config|
        config.track_utms = false
      end
      expect(UniversalTrackManager.track_utms?).to be(false)
    end

    it "should be able to turn track_user_agent off" do
      UniversalTrackManager.configure do |config|
        config.track_user_agent = false
      end
      expect(UniversalTrackManager.track_user_agent?).to be(false)
    end

    it "should be able to turn track_http_referrer off" do
      UniversalTrackManager.configure do |config|
        config.track_http_referrer = false
      end
      expect(UniversalTrackManager.track_http_referrer?).to be(false)
    end
  end
end