class CreateTrackTable < ActiveRecord::Migration
  def self.up
    create_table :track_clients do |t|
      t.string :client_token
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
