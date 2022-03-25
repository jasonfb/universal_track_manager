class UniversalTrackManager::Base < ActiveRecord::Base
  self.abstract_class = true
  def self.table_name_prefix
    ''
  end
end
