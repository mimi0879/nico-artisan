class CreateHistories < ActiveRecord::Migration
  def self.up
    create_table :histories do |t|
      t.references :art
      t.references :comment
      t.string :vid
      t.string :vpos
      t.string :xml, :limit => 1024
      t.string :result, :limit => 1024

      t.timestamps
    end
  end

  def self.down
    drop_table :histories
  end
end
