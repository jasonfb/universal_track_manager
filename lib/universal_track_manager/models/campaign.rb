class UniversalTrackManager::Campaign < ActiveRecord::Base
  self.table_name = "campaigns"

  def name
    if try(:gclid_present)
      "Google Ad"
    elsif utm_source == "email"
      "Email: #{utm_medium} #{utm_campaign} #{utm_content}"

    elsif false #facebook / referral  here

    else
      "Direct: #{utm_source} #{utm_term} #{utm_medium} #{utm_campaign} #{utm_content}"
    end
  end
end