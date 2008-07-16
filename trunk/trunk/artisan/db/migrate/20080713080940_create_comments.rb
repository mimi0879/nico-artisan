class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :art
      t.integer :vpos
      t.string :command
      t.string :text

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
