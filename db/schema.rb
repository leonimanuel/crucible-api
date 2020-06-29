# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_29_232422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "discussion_id"
    t.string "author"
    t.string "date_published"
    t.index ["discussion_id"], name: "index_articles_on_discussion_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.bigint "discussion_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "span_id"
    t.string "selection"
    t.integer "startPoint"
    t.integer "endPoint"
    t.string "previous_el_id"
    t.integer "user_id"
    t.index ["discussion_id"], name: "index_comments_on_discussion_id"
  end

  create_table "discussions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "article_url"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_discussions_on_group_id"
  end

  create_table "facts", force: :cascade do |t|
    t.string "content"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "facts_comments", force: :cascade do |t|
    t.bigint "fact_id", null: false
    t.bigint "comment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["comment_id"], name: "index_facts_comments_on_comment_id"
    t.index ["fact_id"], name: "index_facts_comments_on_fact_id"
  end

  create_table "facts_users", force: :cascade do |t|
    t.integer "fact_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string "text"
    t.bigint "discussion_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discussion_id"], name: "index_messages_on_discussion_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "messages_users_reads", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "user_id", null: false
    t.boolean "read"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id"], name: "index_messages_users_reads_on_message_id"
    t.index ["user_id"], name: "index_messages_users_reads_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.string "ancestry"
    t.index ["ancestry"], name: "index_topics_on_ancestry"
  end

  create_table "topics_facts", force: :cascade do |t|
    t.integer "topic_id"
    t.integer "fact_id"
  end

  create_table "topics_subtopics", force: :cascade do |t|
    t.integer "topic_id"
    t.integer "subtopic_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users_discussions_unread_messages_counts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "discussion_id", null: false
    t.integer "unread_messages", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discussion_id"], name: "index_users_discussions_unread_messages_counts_on_discussion_id"
    t.index ["user_id"], name: "index_users_discussions_unread_messages_counts_on_user_id"
  end

  create_table "users_groups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_users_groups_on_group_id"
    t.index ["user_id"], name: "index_users_groups_on_user_id"
  end

  add_foreign_key "comments", "discussions"
  add_foreign_key "facts_comments", "comments"
  add_foreign_key "facts_comments", "facts"
  add_foreign_key "messages", "discussions"
  add_foreign_key "messages", "users"
  add_foreign_key "messages_users_reads", "messages"
  add_foreign_key "messages_users_reads", "users"
  add_foreign_key "users_discussions_unread_messages_counts", "discussions"
  add_foreign_key "users_discussions_unread_messages_counts", "users"
  add_foreign_key "users_groups", "groups"
  add_foreign_key "users_groups", "users"
end
