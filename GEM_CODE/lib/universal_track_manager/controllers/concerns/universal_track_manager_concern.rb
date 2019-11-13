module UniversalTrackManagerConcern
  extend ActiveSupport::Concern

  included do
    before_action :track_visitor
  end

  def track_visitor
    puts "***************"

    # pick up IP, referrer, and user_agent from request
    puts request.ip
    puts request.referrer
    puts request.user_agent

    # pick up utm_campaign, utm_medium, utm_source, utm_campaign from the URL parameters
    # pick up gclid from the URL parameters
  end
end