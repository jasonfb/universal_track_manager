module UniversalTrackManagerConcern
  extend ActiveSupport::Concern

  included do
    before_action :track_visitor
  end

  def permitted_utm_params
    params.permit(:utm_campaign, :utm_source, :utm_term, :utm_content, :utm_medium)
  end

  def track_visitor
    ip_address = request.ip
    user_agent = request.user_agent[0..255]

    utm_campaign = permitted_utm_params[:utm_campaign]
    utm_source = permitted_utm_params[:utm_source]
    utm_term = permitted_utm_params[:utm_term]
    utm_content = permitted_utm_params[:utm_content]
    utm_medium = permitted_utm_params[:utm_medium]

    if session['visit_id'] # existing visit
      existing_visit = UniversalTrackManager::Visit.find(session['visit_id'])

    else # new visit

      browser = UniversalTrackManager::Browser.find_or_create_by(browser_name: user_agent)


      # please note that nil is nil in the database and
      # empty string is empty string. if campaign parameters
      # are attached to inbound links as empty string, they will create
      # distinct records from those where no parameter was passed

      campaign = UniversalTrackManager::Campaign.find_or_create_by(
        utm_campaign: utm_campaign,
        utm_source: utm_source,
        utm_term: utm_term,
        utm_content: utm_content,
        utm_medium: utm_medium
      )

      visit = UniversalTrackManager::Visit.create!(ip_v4_address: ip_address,
                                                   browser: browser,
                                                   campaign: campaign)

      session[:visit_id] = visit.id
    end
  end
end