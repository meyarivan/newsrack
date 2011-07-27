/** TABLE: feeds **/

ALTER TABLE feeds CHANGE feed_key id int not null auto_increment;
ALTER TABLE feeds ADD created_at datetime not null; 
ALTER TABLE feeds ADD updated_at datetime not null; 

/** TABLE: news_indexes **/

ALTER TABLE news_indexes CHANGE ni_key id int not null auto_increment;
ALTER TABLE news_indexes CHANGE feed_key feed_id int not null;
ALTER TABLE news_indexes MODIFY created_at datetime not null;

/* is FK automatically managed by mysql ? */

/** TABLE: news_items **/
ALTER TABLE news_items CHANGE n_key id int not null auto_increment;
ALTER TABLE news_items CHANGE primary_ni_key primary_news_index_id int not null;

/** TABLE: news_item_url_md5_hashes **/

ALTER TABLE news_item_url_md5_hashes CHANGE n_key news_item_id int not null;

/** TABLE: news_item_localnames **/

ALTER TABLE news_item_localnames CHANGE n_key news_item_id int not null;

/** TABLE: news_collections **/

ALTER TABLE news_collections CHANGE n_key news_item_id int not null;
ALTER TABLE news_collections CHANGE ni_key news_index_id int not null;
ALTER TABLE news_collections CHANGE feed_key feed_id int not null;
ALTER TABLE news_collections RENAME news_collection_entries;

/** TABLE: downloaded_news **/

ALTER TABLE downloaded_news CHANGE n_key news_item_id int not null;
ALTER TABLE downloaded_news CHANGE feed_key feed_id int not null;
ALTER TABLE downloaded_news RENAME downloaded_news_items;

/** TABLE: users **/

ALTER TABLE users CHANGE u_key id int not null auto_increment;
ALTER TABLE users CHANGE regn_date created_at datetime not null; 
ALTER TABLE users CHANGE last_update updated_at datetime not null;


/** TABLE: import_dependencies **/

ALTER TABLE import_dependencies CHANGE importing_user_key importing_user_id int not null;
ALTER TABLE import_dependencies CHANGE from_user_key from_user_id int not null;

/** TABLE: topics **/

ALTER TABLE topics CHANGE t_key id int not null auto_increment;
ALTER TABLE topics CHANGE u_key user_id int not null;
ALTER TABLE topics ADD created_at datetime not null; 
ALTER TABLE topics ADD updated_at datetime not null; 

/** TABLE: categories **/

ALTER TABLE categories CHANGE c_key id int not null auto_increment;
ALTER TABLE categories CHANGE u_key user_id int not null;
ALTER TABLE categories CHANGE t_key topic_id int;
ALTER TABLE categories MODIFY cat_id int not null;
ALTER TABLE categories CHANGE parent_cat parent_cat_id int not null default -1;
ALTER TABLE categories CHANGE f_key filter_id int;

ALTER TABLE categories ADD created_at datetime not null; 
ALTER TABLE categories CHANGE last_update updated_at datetime not null;

/** TABLE: cat_news **/

ALTER TABLE cat_news CHANGE c_key category_id int not null;
ALTER TABLE cat_news CHANGE n_key news_item_id int not null;
ALTER TABLE cat_news CHANGE ni_key news_index_id int not null;

/* date_stamp should be renamed to created_at ? */

/** TABLE: user_files **/

ALTER TABLE user_files CHANGE file_key id int not null auto_increment;
ALTER TABLE user_files CHANGE u_key user_id int not null;

ALTER TABLE user_files MODIFY created_at datetime not null; 
ALTER TABLE user_files ADD updated_at datetime not null;

/** TABLE: user_collections **/

ALTER TABLE user_collections CHANGE coll_key id int not null auto_increment;
ALTER TABLE user_collections CHANGE u_key user_id int not null;
ALTER TABLE user_collections CHANGE file_key user_file_id int not null;

/** TABLE: collection_entries **/

ALTER TABLE collection_entries CHANGE coll_key collection_id int not null;
ALTER TABLE collection_entries CHANGE entry_key entry_id int not null;
ALTER TABLE collection_entries ADD entry_type varchar(255) not null;
/* changing entry_type into a int which is an index into table of types saves space ? */

/** TABLE: sources **/

ALTER TABLE sources CHANGE src_key id int not null auto_increment;
ALTER TABLE sources CHANGE feed_key feed_id int not null;
ALTER TABLE sources CHANGE u_key user_id int not null;


/** TABLE: topic_sources **/

ALTER TABLE topic_sources CHANGE t_key topic_id int not null;
ALTER TABLE topic_sources CHANGE src_key source_id int not null;
ALTER TABLE topic_sources CHANGE feed_key feed_id int not null;
ALTER TABLE topic_sources CHANGE max_ni_key max_news_index_id int not null default 0;

/** TABLE: concepts **/

ALTER TABLE concepts CHANGE cpt_key id int not null auto_increment;
ALTER TABLE concepts CHANGE u_key user_id int not null;

/** TABLE: filters **/

ALTER TABLE filters CHANGE f_key id int not null auto_increment;
ALTER TABLE filters CHANGE u_key user_id int not null;
ALTER TABLE filters CHANGE rule_key root_rule_term_id int not null;

/** TABLE: filter_rule_terms **/

ALTER TABLE filter_rule_terms CHANGE rt_key id int not null auto_increment;
ALTER TABLE filter_rule_terms CHANGE f_key filter_id int not null;
ALTER TABLE filter_rule_terms MODIFY term_type int not null;
ALTER TABLE filter_rule_terms CHANGE arg1_key arg1_id int not null;
ALTER TABLE filter_rule_terms CHANGE arg2_key arg2_id int;

/** TABLE: recent_news_title_hashes **/
ALTER TABLE recent_news_title_hashes CHANGE n_key news_item_id int not null;

/* DONE */
