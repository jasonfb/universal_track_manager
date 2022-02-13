class UniversalTrackManager::Campaign < ActiveRecord::Base
  self.table_name = "campaigns"

  def name
    "#{utm_source} #{utm_medium} #{utm_campaign} #{utm_content} #{utm_term}"
  end
end