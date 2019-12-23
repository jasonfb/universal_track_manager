class UniversalTrackManager::Visit < ActiveRecord::Base
  self.table_name = "visits"

  belongs_to :campaign, class_name: "UniversalTrackManager::Campaign"
  belongs_to :browser, class_name: "UniversalTrackManager::Browser"


  def matches_all_utms?(params)
    if !campaign
      # this visit has no campaign, which means all UTMs = null
      # if any of the UTMs are present, return false (they don't match null)
      return ! [:utm_campaign, :utm_source, :utm_medium, :utm_term, :utm_content].any? do |key|
        params[key].present?
      end
    end

    # note params are allowed to be missing
    return campaign.utm_campaign == params[:utm_campaign] &&
      campaign.utm_source == params[:utm_source] &&
      campaign.utm_medium == params[:utm_medium] &&
      campaign.utm_term == params[:utm_term] &&
      campaign.utm_content == params[:utm_content]
  end
end
