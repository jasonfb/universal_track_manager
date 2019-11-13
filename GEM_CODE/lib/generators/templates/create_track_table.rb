class CreateTrackTable < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      create_table :browsers do |t|
        # this table gets automatically populated by inbound traffic
        t.string :browser_name, size: 255
      end

      create_table :campaigns do |t|
        # this table gets automatically populated by inbound traffic
        t.string :source
        t.string :medium
        t.string :campaign
        t.string :content
        t.string :term
        t.timestamps
      end

      create_table :visits do |t|
        t.datetime :first_pageload
        t.datetime :last_pageload

        t.integer :utm_id
        t.integer :browser_id
        t.string :ip_address

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
