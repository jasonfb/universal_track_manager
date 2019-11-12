class CreateTrackTable < ActiveRecord::Migration
  def self.up
    create_table :browsers do |t|
      # this table gets automatically populated by inbound traffic
      t.string :browser_name, size: 255
    end

    create_table :utms do |t|
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

      t.string :session_id
      t.timestamps
    end
    
    create_table :track_data do |t|
      t.integer :track_client_id
      t.integer :kind_id
      t.string :data
      t.datetime :created_at
    end
    
    create_table :track_kind do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :track
  end
end
