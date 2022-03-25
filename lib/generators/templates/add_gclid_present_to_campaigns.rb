class AddGclidPresentToCampaigns < ActiveRecord::Migration<%= migration_version %>
  def self.up
    add_column :campaigns, :gclid_present, :boolean
  end

  def self.down
    remove_column :campaigns, :gclid_present, :boolean
  end
end
