class UniversalTrackManager::Campaign < ActiveRecord::Base
  self.table_name = "campaigns"

  def name
    if try(:gclid_present)
      "Google Ad"
    elsif utm_source == "email"
      "Email: #{utm_medium} #{utm_campaign} #{utm_content}"
    elsif utm_source.empty? && utm_term.empty? && utm_medium.empty? && utm_campaign.empty? && utm_content.empty?
      "Direct"
    else
      "#{utm_source} #{utm_term} #{utm_medium} #{utm_campaign} #{utm_content}"
    end

    # TODO: Add referral & Facebook/other social medial
  end
end