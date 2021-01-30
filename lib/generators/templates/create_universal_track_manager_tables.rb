class CreateUniversalTrackManagerTables < ActiveRecord::Migration<%= migration_version %>
  def self.up
    ActiveRecord::Base.transaction do

      create_table :browsers do |t|
        # this table gets automatically populated by inbound traffic
        t.string :name, size: 255
      end

      add_index :browsers, :name

      create_table :campaigns do |t|
        # this table gets automatically populated by inbound traffic
        #GENERATOR INSERTS CAMPAIGN COLUMNS HERE
        t.timestamps
      end

      #GENERATOR INSERTS CAMPAIGN INDEX HERE

      create_table :visits do |t|
        t.datetime :first_pageload
        t.datetime :last_pageload
        t.integer :original_visit_id
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
