class CreateUniversalTrackManagerTables < ActiveRecord::Migration<%= migration_version %>
  def self.up
    ActiveRecord::Base.transaction do

      create_table :browsers do |t|
        # this table gets automatically populated by inbound traffic
        t.string :browser_name, size: 255
      end

      add_index :browser_name

      create_table :campaigns do |t|
        # this table gets automatically populated by inbound traffic
        t.string :utm_source, limit: 50
        t.string :utm_medium, limit: 50
        t.string :utm_campaign, limit: 50
        t.string :utm_content, limit: 50
        t.string :utm_term, limit: 50
        t.timestamps
      end

      add_index :campaigns, [:utm_source, :utm_medium, :utm_campaign, :utm_content, :utm_term], name: "utm_all_combined"

      create_table :visits do |t|
        t.datetime :first_pageload
        t.datetime :last_pageload

        t.integer :campaign_id
        t.integer :browser_id
        t.string :ip_v4_address, length: 15

        t.integer :viewport_width
        t.integer :viewport_height
      end
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      drop_table :browsers
      drop_table :visits
      drop_table :campaigns
    end
  end
end
