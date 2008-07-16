class CreateArts < ActiveRecord::Migration
  def self.up
    create_table :arts do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :arts
  end
end
