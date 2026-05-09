class UniversalTrackManager::Browser < ActiveRecord::Base
  def self.table_name
    UniversalTrackManager.prefixed_table_name("browsers")
  end

end
