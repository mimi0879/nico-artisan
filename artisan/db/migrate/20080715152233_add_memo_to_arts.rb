class AddMemoToArts < ActiveRecord::Migration
  def self.up
    add_column :arts, :memo, :text
  end

  def self.down
    remove_column :arts, :memo
  end
end
