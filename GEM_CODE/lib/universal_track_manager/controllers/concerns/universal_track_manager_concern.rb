module UniversalTrackManagerConcern
  extend ActiveSupport::Concern

  included do
    before_action :track_visitor
  end

  def track_visitor
    ip_address = request.ip
    user_agent = request.user_agent
    # utm_campaign = params.permit(:utm_campaign)
    # utm_source = params.permit(:utm_source)
    # utm_keyword = params.permit(:utm_keyword)
    # utm_content = params.permit(:utm_content)
    # utm_medium = params.permit(:utm_medium)

    if session['visit_id']
      existing_visit = UniversalTrackManager::Visit.find(session['visit_id'])
    else
      visit = UniversalTrackManager::Visit.create!(ip_v4_address: ip_address)
      session[:visit_id] = visit.id
    end
  end
end