class AddVideoIdToArts < ActiveRecord::Migration
  def self.up
    add_column :arts, :video_id, :integer
  end

  def self.down
    remove_column :arts, :video_id
  end
end
