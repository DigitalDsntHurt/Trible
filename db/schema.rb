# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170201192305) do

  create_table "bible_verses", force: :cascade do |t|
    t.string   "verse_num"
    t.string   "verse_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mashups", force: :cascade do |t|
    t.string   "mashup_text"
    t.boolean  "tweet?",      default: false
    t.boolean  "tweeted?",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "trump_tweets", force: :cascade do |t|
    t.string   "tweet_created"
    t.string   "tweet_text"
    t.string   "tweet_is_rt"
    t.string   "tweet_in_reply_to_screenname"
    t.integer  "tweet_fav_count"
    t.integer  "tweet_rt_count"
    t.string   "tweet_source"
    t.string   "tweet_id_string"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

end
