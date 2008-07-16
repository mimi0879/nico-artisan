class CreateChats < ActiveRecord::Migration
  def self.up
    create_table :chats do |t|
      t.references :video
      t.integer :vpos
      t.string :mail
      t.string :text
      t.datetime :date
      t.integer :no
      t.string :user_id
      t.boolean :premium
      t.boolean :anonymity
      t.integer :thread

      t.timestamps
    end
  end

  def self.down
    drop_table :chats
  end
end
