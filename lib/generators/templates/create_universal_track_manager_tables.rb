class CreateUniversalTrackManagerTables < ActiveRecord::Migration<%= migration_version %>
  def self.up
    ActiveRecord::Base.transaction do
      prefix = "<%= @table_prefix %>"

      create_table :"#{prefix}browsers" do |t|
        # this table gets automatically populated by inbound traffic
        t.string :name, limit: 255
        t.timestamps
      end

      add_index :"#{prefix}browsers", :name

      create_table :"#{prefix}campaigns" do |t|
        # this table gets automatically populated by inbound traffic
#GENERATOR INSERTS CAMPAIGN COLUMNS HERE
        t.string :sha1, limit: 40
        t.boolean :gclid_present
        t.timestamps
      end

      add_index :"#{prefix}campaigns", :sha1

      create_table :"#{prefix}visits" do |t|
        t.datetime :first_pageload
        t.datetime :last_pageload
        t.integer :original_visit_id
        t.integer :campaign_id
        t.integer :browser_id
        t.string :ip_v4_address, limit: 15

        t.integer :viewport_width
        t.integer :viewport_height
        t.integer :count, default: 1
        t.timestamps
      end
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      prefix = "<%= @table_prefix %>"

      drop_table :"#{prefix}browsers"
      drop_table :"#{prefix}visits"
      drop_table :"#{prefix}campaigns"
    end
  end
end
