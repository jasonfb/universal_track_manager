class UniversalTrackManager::Campaign < ActiveRecord::Base
  def self.table_name
    UniversalTrackManager.prefixed_table_name("campaigns")
  end

end
