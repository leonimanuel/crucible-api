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

ActiveRecord::Schema.define(version: 2020_07_17_022639) do

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
    t.integer "selection_comment_upvotes", default: 0
    t.integer "selection_comment_downvotes", default: 0
    t.string "review_status", default: "pending"
    t.index ["discussion_id"], name: "index_comments_on_discussion_id"
  end

  create_table "discussion_unread_messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "discussion_id", null: false
    t.integer "unread_messages", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discussion_id"], name: "index_discussion_unread_messages_on_discussion_id"
    t.index ["user_id"], name: "index_discussion_unread_messages_on_user_id"
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
    t.integer "logic_upvotes", default: 0
    t.integer "logic_downvotes", default: 0
    t.string "review_status", default: "pending"
    t.integer "context_upvotes", default: 0
    t.integer "context_downvotes", default: 0
    t.integer "credibility_upvotes", default: 0
    t.integer "credibility_downvotes", default: 0
  end

  create_table "facts_comments", force: :cascade do |t|
    t.bigint "fact_id", null: false
    t.bigint "comment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "comment_fact_upvotes", default: 0
    t.integer "comment_fact_downvotes", default: 0
    t.string "review_status", default: "pending"
    t.index ["comment_id"], name: "index_facts_comments_on_comment_id"
    t.index ["fact_id"], name: "index_facts_comments_on_fact_id"
  end

  create_table "facts_reviews", force: :cascade do |t|
    t.bigint "fact_id", null: false
    t.bigint "user_id", null: false
    t.string "review_type"
    t.string "review_result"
    t.string "review_reason"
    t.string "review_comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fact_id"], name: "index_facts_reviews_on_fact_id"
    t.index ["user_id"], name: "index_facts_reviews_on_user_id"
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
    t.integer "discussion_id"
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

  create_table "users_groups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_users_groups_on_group_id"
    t.index ["user_id"], name: "index_users_groups_on_user_id"
  end

  create_table "users_reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "review_object"
    t.integer "object_id"
    t.string "review_type"
    t.string "decision"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_users_reviews_on_user_id"
  end

  add_foreign_key "comments", "discussions"
  add_foreign_key "discussion_unread_messages", "discussions"
  add_foreign_key "discussion_unread_messages", "users"
  add_foreign_key "facts_comments", "comments"
  add_foreign_key "facts_comments", "facts"
  add_foreign_key "facts_reviews", "facts"
  add_foreign_key "facts_reviews", "users"
  add_foreign_key "messages", "discussions"
  add_foreign_key "messages", "users"
  add_foreign_key "messages_users_reads", "messages"
  add_foreign_key "messages_users_reads", "users"
  add_foreign_key "users_groups", "groups"
  add_foreign_key "users_groups", "users"
  add_foreign_key "users_reviews", "users"
end
