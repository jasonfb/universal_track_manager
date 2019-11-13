module UniversalTrackManagerConcern
  extend ActiveSupport::Concern

  included do
    before_action :track_visitor
  end


  def track_visitor
    puts "***************"

    # IP, referrer, and user_agent automatically picked up from request
    puts request.ip
    puts  request.referrer
    puts  request.user_agent

    # pick up utm_campaign, utm_medium, utm_


  end
end