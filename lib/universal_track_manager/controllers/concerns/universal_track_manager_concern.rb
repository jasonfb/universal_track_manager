module UniversalTrackManagerConcern
  extend ActiveSupport::Concern
  attr_accessor :visit_evicted



  included do
    before_action :track_visitor

    UniversalTrackManager.campaign_column_symbols.each do |s|
      define_method(s) do
        return nil if ! UniversalTrackManager.track_utms?
        permitted_utm_params[s]
      end
    end
  end

  def permitted_utm_params
    params.permit(*(UniversalTrackManager.campaign_column_symbols))
  end


  def ip_address
    return nil if ! UniversalTrackManager.track_ips?
    request.ip
  end

  def user_agent
    return nil if ! UniversalTrackManager.track_user_agent?
    request.user_agent && request.user_agent[0..254]
  end

  def now
    @now ||= Time.now
  end

  def new_visitor
    params = {
      first_pageload: now,
      last_pageload: now,
      ip_v4_address: ip_address,
      campaign: find_or_create_campaign_by_current
    }
    params[:browser] =  find_or_create_browser_by_current if request.user_agent
    visit = UniversalTrackManager::Visit.create!(params)
    session[:visit_id] = visit.id
  end

  def track_visitor
    if !session['visit_id']
      new_visitor
    else
      # existing visit
      begin
        existing_visit = UniversalTrackManager::Visit.find(session['visit_id'])

        evict_visit!(existing_visit) if any_utm_params? && !existing_visit.matches_all_utms?(permitted_utm_params)

        evict_visit!(existing_visit) if existing_visit.ip_v4_address != ip_address
        evict_visit!(existing_visit) if existing_visit.browser && existing_visit.browser.name != user_agent

        existing_visit.update_columns(:last_pageload => Time.now) if !@visit_evicted
      rescue ActiveRecord::RecordNotFound
        # this happens if the session table is cleared or if the record in the session
        # table points to a visit that has been cleared
        new_visitor
      end
    end
  end


  def any_utm_params?
    return false if ! UniversalTrackManager.track_utms?
    UniversalTrackManager.campaign_column_symbols.any? do |key|
      params[key].present?
    end
  end

  def find_or_create_browser_by_current
    return nil if ! UniversalTrackManager.track_user_agent?
    browser = UniversalTrackManager::Browser.find_or_create_by(name: user_agent)
  end

  def find_or_create_campaign_by_current
    return nil if ! UniversalTrackManager.track_utms?
    gen_sha1 = gen_campaign_key(permitted_utm_params)

    # find_or_create_by finding only by sha1 would be nice here, but how to do so with a dynamic set of columns?
    # we've got a small chance of dups here due to the non-atomic find/create and sha1, but that's ok for this application.
    c = UniversalTrackManager::Campaign.find_by(sha1: gen_sha1)
    c ||= UniversalTrackManager::Campaign.create(*(permitted_utm_params.merge({"sha1": gen_sha1})))
  end

  def gen_campaign_key(params)
    Digest::SHA1.hexdigest(params.keys.map{|k| k.downcase()}.sort.map{|k| {"#{k}":  params[k]}}.to_s)
  end

  def evict_visit!(old_visit)
    @visit_evicted = true
    params = {
      first_pageload: now,
      last_pageload: now,
      original_visit_id: old_visit.original_visit_id.nil? ?  old_visit.id : old_visit.original_visit_id,
      ip_v4_address: ip_address,
      campaign: find_or_create_campaign_by_current
    }

    # fail silently if there is no user agent
    params[:browser] =  find_or_create_browser_by_current if request.user_agent
    visit = UniversalTrackManager::Visit.create!(params)

    session[:visit_id] = visit.id
  end
end
