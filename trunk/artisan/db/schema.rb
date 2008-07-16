# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080715152233) do

  create_table "accounts", :force => true do |t|
    t.string   "c_mail"
    t.string   "c_password"
    t.string   "identity_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "arts", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "video_id"
    t.text     "memo"
  end

  create_table "chats", :force => true do |t|
    t.integer  "video_id"
    t.integer  "vpos"
    t.string   "mail"
    t.string   "text"
    t.datetime "date"
    t.integer  "no"
    t.string   "user_id"
    t.boolean  "premium"
    t.boolean  "anonymity"
    t.integer  "thread"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "art_id"
    t.integer  "vpos"
    t.string   "command"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "histories", :force => true do |t|
    t.integer  "art_id"
    t.integer  "comment_id"
    t.string   "vid"
    t.string   "vpos"
    t.string   "xml",        :limit => 1024
    t.string   "result",     :limit => 1024
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "videos", :force => true do |t|
    t.string   "vid"
    t.string   "url"
    t.string   "title"
    t.string   "tags"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
