class UniversalTrackManager::Visit < ActiveRecord::Base
  self.table_name = "visits"

  belongs_to :campaign, class_name: "UniversalTrackManager::Campaign"
  belongs_to :browser, class_name: "UniversalTrackManager::Browser"
  belongs_to :original_visit,  optional: true, class_name: "UniversalTrackManager::Visit"

  def matches_all_utms?(params)
    if !campaign
      # this visit has no campaign, which means all UTMs = null
      # if any of the UTMs are present, return false (they don't match null)
      return ! UniversalTrackManager.campaign_column_symbols.any? do |key|
        params[key].present?
      end
    end

    # note params are allowed to be missing
    UniversalTrackManager.campaign_column_symbols.each do |c|
      if (campaign[c] && (campaign[c] != params[c])) || (!campaign[c] && params[c])
        return false
      end
    end
    return true
  end

  default_scope { order(last_pageload: :desc) }

  def name
    "#{ip_v4_address} #{browser.name}"
  end
end
