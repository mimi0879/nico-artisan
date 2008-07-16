class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :vid
      t.string :url
      t.string :title
      t.string :tags
      t.datetime :published_at

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
