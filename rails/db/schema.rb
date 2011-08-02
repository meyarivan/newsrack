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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "cat_news", :id => false, :force => true do |t|
    t.integer "category_id",   :null => false
    t.integer "news_item_id",  :null => false
    t.integer "news_index_id", :null => false
    t.date    "date_stamp",    :null => false
  end

  add_index "cat_news", ["category_id", "news_index_id", "news_item_id"], :name => "unique_index", :unique => true
  add_index "cat_news", ["date_stamp"], :name => "d_index"
  add_index "cat_news", ["news_index_id"], :name => "fk_cat_news_3"
  add_index "cat_news", ["news_item_id"], :name => "n_index"

  create_table "categories", :force => true do |t|
    t.boolean  "valid",                           :default => true
    t.string   "name",             :limit => 256,                   :null => false
    t.integer  "user_id",                                           :null => false
    t.integer  "topic_id"
    t.integer  "cat_id",                                            :null => false
    t.integer  "parent_cat_id",                   :default => -1,   :null => false
    t.integer  "filter_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "updated_at",                                        :null => false
    t.integer  "num_articles",                    :default => 0
    t.text     "taxonomy_path"
    t.integer  "num_new_articles",                :default => 0
    t.datetime "created_at",                                        :null => false
  end

  add_index "categories", ["filter_id"], :name => "fk_categories_1"
  add_index "categories", ["user_id", "topic_id"], :name => "uid_issue_index"

  create_table "collection_entries", :id => false, :force => true do |t|
    t.integer "collection_id", :null => false
    t.integer "entry_id",      :null => false
    t.string  "entry_type",    :null => false
  end

  add_index "collection_entries", ["collection_id"], :name => "fk_collection_entries_1"

  create_table "concepts", :force => true do |t|
    t.integer "user_id",                 :null => false
    t.string  "name",     :limit => 64,  :null => false
    t.text    "defn",                    :null => false
    t.text    "keywords",                :null => false
    t.string  "token",    :limit => 128
  end

  add_index "concepts", ["user_id"], :name => "fk_concepts_1"

  create_table "downloaded_new_items", :id => false, :force => true do |t|
    t.integer "feed_id",      :null => false
    t.integer "news_item_id", :null => false
  end

  add_index "downloaded_news_items", ["feed_id"], :name => "fk_downloaded_news_1"
  add_index "downloaded_news_items", ["news_item_id"], :name => "fk_downloaded_news_2"

  create_table "feeds", :force => true do |t|
    t.string   "feed_tag",                      :limit => 64
    t.string   "feed_name",                     :limit => 128,                     :null => false
    t.string   "url",                           :limit => 2048,                    :null => false
    t.boolean  "cacheable",                                     :default => true
    t.boolean  "use_ignore_comments_heuristic",                 :default => true
    t.boolean  "show_cache_links",                              :default => false
    t.integer  "mins_between_downloads",                        :default => 120
    t.integer  "num_fetches"
    t.integer  "num_failures"
    t.boolean  "dead"
    t.string   "publication"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_index "feeds", ["feed_tag"], :name => "feed_tag", :unique => true

  create_table "filter_rule_terms", :force => true do |t|
    t.integer "filter_id", :null => false
    t.integer "term_type", :null => false
    t.integer "arg1_id",   :null => false
    t.integer "arg2_id"
  end

  add_index "filter_rule_terms", ["filter_id"], :name => "fk_filter_rule_terms_1"

  create_table "filters", :force => true do |t|
    t.integer "user_id",                                         :null => false
    t.string  "name",              :limit => 256,                :null => false
    t.text    "rule_string",                                     :null => false
    t.integer "root_rule_term_id",                               :null => false
    t.integer "min_match_score",                  :default => 2
  end

  create_table "import_dependencies", :id => false, :force => true do |t|
    t.integer "importing_user_id", :null => false
    t.integer "from_user_id",      :null => false
  end

  add_index "import_dependencies", ["from_user_id"], :name => "fk_import_dependencies_1"
  add_index "import_dependencies", ["importing_user_id", "from_user_id"], :name => "importing_user_key", :unique => true

  create_table "news_collection_entries", :id => false, :force => true do |t|
    t.integer "news_index_id", :null => false
    t.integer "news_item_id",  :null => false
    t.integer "feed_id",       :null => false
  end

  add_index "news_collection_entries", ["feed_id"], :name => "fk_news_collections_3"
  add_index "news_collection_entries", ["news_index_id", "news_item_id"], :name => "ni_key", :unique => true
  add_index "news_collection_entries", ["news_item_id"], :name => "fk_news_collections_2"

  create_table "news_indexes", :force => true do |t|
    t.integer  "feed_id",    :null => false
    t.datetime "created_at", :null => false
  end

  add_index "news_indexes", ["created_at"], :name => "time_stamp_index"
  add_index "news_indexes", ["feed_id"], :name => "feed_index"

  create_table "news_item_localnames", :id => false, :force => true do |t|
    t.integer "news_item_id",                   :null => false
    t.string  "local_file_name", :limit => 256, :null => false
  end

  add_index "news_item_localnames", ["local_file_name"], :name => "file_name_index"
  add_index "news_item_localnames", ["news_item_id"], :name => "fk_1"

  create_table "news_item_url_md5_hashes", :id => false, :force => true do |t|
    t.integer "news_item_id",               :null => false
    t.string  "url_hash",     :limit => 32, :null => false
  end

  add_index "news_item_url_md5_hashes", ["news_item_id"], :name => "fk_1"
  add_index "news_item_url_md5_hashes", ["url_hash"], :name => "hash_index"

  create_table "news_items", :force => true do |t|
    t.integer "primary_news_index_id",                :null => false
    t.string  "url_root",              :limit => 128, :null => false
    t.string  "url_tail",              :limit => 256, :null => false
    t.text    "title",                                :null => false
    t.text    "description"
    t.text    "author"
  end

  add_index "news_items", ["primary_news_index_id"], :name => "fk_news_items_1"

  create_table "recent_news_title_hashes", :id => false, :force => true do |t|
    t.integer "news_item_id",               :null => false
    t.string  "title_hash",   :limit => 32
    t.date    "story_date"
  end

  add_index "recent_news_title_hashes", ["news_item_id"], :name => "fk_recent_news_title_hashes_1"
  add_index "recent_news_title_hashes", ["title_hash"], :name => "title_hash_index"

  create_table "sources", :force => true do |t|
    t.integer "feed_id",                                            :null => false
    t.integer "user_id",                                            :null => false
    t.string  "src_tag",          :limit => 256,                    :null => false
    t.string  "src_name",         :limit => 256,                    :null => false
    t.boolean "cacheable",                       :default => true
    t.boolean "show_cache_links",                :default => false
  end

  add_index "sources", ["feed_id"], :name => "fk_sources_1"
  add_index "sources", ["user_id", "feed_id", "src_tag"], :name => "u_key", :unique => true

  create_table "tags", :id => false, :force => true do |t|
    t.integer "tag_key"
    t.string  "taggable_type", :limit => 16
    t.integer "taggable_id",   :limit => 8
  end

  add_index "tags", ["taggable_type", "taggable_id"], :name => "tags_hash"

  create_table "topic_sources", :id => false, :force => true do |t|
    t.integer "topic_id",                         :null => false
    t.integer "source_id",                        :null => false
    t.integer "feed_id",                          :null => false
    t.integer "max_news_index_id", :default => 0, :null => false
  end

  add_index "topic_sources", ["feed_id"], :name => "fk_topic_sources_3"
  add_index "topic_sources", ["source_id"], :name => "fk_topic_sources_2"
  add_index "topic_sources", ["topic_id"], :name => "fk_topic_sources_1"

  create_table "topics", :force => true do |t|
    t.integer   "user_id",                                            :null => false
    t.string    "name",             :limit => 256,                    :null => false
    t.integer   "num_articles",                    :default => 0
    t.timestamp "last_update",                                        :null => false
    t.boolean   "validated",                       :default => false
    t.boolean   "frozen",                          :default => false
    t.boolean   "private",                         :default => false
    t.text      "taxonomy_path"
    t.integer   "num_new_articles",                :default => 0
    t.datetime  "created_at",                                         :null => false
    t.datetime  "updated_at",                                         :null => false
  end

  add_index "topics", ["user_id"], :name => "fk_topics_1"

  create_table "user_collections", :force => true do |t|
    t.integer "user_file_id",               :null => false
    t.string  "coll_name",    :limit => 64, :null => false
    t.string  "coll_type",    :limit => 3,  :null => false
    t.integer "user_id",                    :null => false
    t.string  "uid",          :limit => 32, :null => false
  end

  add_index "user_collections", ["user_file_id"], :name => "fk_user_collections_2"
  add_index "user_collections", ["user_id"], :name => "fk_user_collections_1"

  create_table "user_files", :force => true do |t|
    t.integer  "user_id",                   :null => false
    t.string   "file_name",  :limit => 256, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "user_files", ["user_id"], :name => "fk_user_files_1"

  create_table "users", :force => true do |t|
    t.string    "uid",        :limit => 32,                     :null => false
    t.string    "password",   :limit => 32,                     :null => false
    t.string    "name",       :limit => 256,                    :null => false
    t.string    "email",      :limit => 256,                    :null => false
    t.boolean   "validated",                 :default => false
    t.datetime  "created_at",                                   :null => false
    t.datetime  "updated_at",                                   :null => false
    t.timestamp "last_login",                                   :null => false
  end

  add_index "users", ["uid"], :name => "uid", :unique => true

end
