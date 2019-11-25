class UniversalTrackManager::Visit < ActiveRecord::Base
  self.table_name = "visits"

  belongs_to :campaign, class_name: "UniversalTrackManager::Campaign"
  belongs_to :browser, class_name: "UniversalTrackManager::Browser"
end
