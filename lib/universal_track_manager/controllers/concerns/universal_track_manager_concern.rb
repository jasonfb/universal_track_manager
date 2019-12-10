module UniversalTrackManagerConcern
  extend ActiveSupport::Concern

  included do
    before_action :track_visitor
  end

  def permitted_utm_params
    params.permit(:utm_campaign, :utm_source, :utm_term, :utm_content, :utm_medium)
  end


  def ip_address
    request.ip
  end

  def user_agent
    request.user_agent[0..255]
  end


  def utm_campaign
    permitted_utm_params[:utm_campaign]
  end

  def utm_source
    permitted_utm_params[:utm_source]
  end

  def utm_term
    permitted_utm_params[:utm_term]
  end

  def utm_content
    permitted_utm_params[:utm_content]
  end

  def utm_medium
    permitted_utm_params[:utm_medium]
  end


  def track_visitor
    if session['visit_id'] # existing visit
      existing_visit = UniversalTrackManager::Visit.find(session['visit_id'])

      if existing_visit.ip_v4_address != ip_address
        evict_visit!(existing_visit)
      end


    else # new visit
      # please note that nil is nil in the database and
      # empty string is empty string. if campaign parameters
      # are attached to inbound links as empty string, they will create
      # distinct records from those where no parameter was passed

      visit = UniversalTrackManager::Visit.create!(ip_v4_address: ip_address,
                                                   browser: find_or_create_browser_by_current,
                                                   campaign: find_or_create_campaign_by_current)

      session[:visit_id] = visit.id
    end
  end

  def find_or_create_browser_by_current
    browser = UniversalTrackManager::Browser.find_or_create_by(browser_name: user_agent)
  end

  def find_or_create_campaign_by_current
    campaign = UniversalTrackManager::Campaign.find_or_create_by(
      utm_campaign: utm_campaign,
      utm_source: utm_source,
      utm_term: utm_term,
      utm_content: utm_content,
      utm_medium: utm_medium
    )
  end

  def evict_visit!(old_visit)
    visit = UniversalTrackManager::Visit.create!(
              genesis_visit_id: old_visit.genesis_visit_id.nil? ?  old_visit.id : old_visit.genesis_visit_id,
              ip_v4_address: ip_address,
              browser: find_or_create_browser_by_current,
              campaign: find_or_create_campaign_by_current)

    session[:visit_id] = visit.id
  end
end