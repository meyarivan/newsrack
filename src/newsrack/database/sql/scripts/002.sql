alter table feeds convert to character set utf8 collate utf8_bin;
alter table news_indexes convert to character set utf8 collate utf8_bin;
alter table news_items convert to character set utf8 collate utf8_bin;
alter table news_item_url_md5_hashes convert to character set utf8 collate utf8_bin;
alter table news_item_localnames convert to character set utf8 collate utf8_bin;
alter table news_collections convert to character set utf8 collate utf8_bin;
alter table users convert to character set utf8 collate utf8_bin;
alter table import_dependencies convert to character set utf8 collate utf8_bin;
alter table topics convert to character set utf8 collate utf8_bin;
alter table categories convert to character set utf8 collate utf8_bin;
alter table cat_news convert to character set utf8 collate utf8_bin;
alter table user_files convert to character set utf8 collate utf8_bin;
alter table user_collections convert to character set utf8 collate utf8_bin;
alter table collection_entries convert to character set utf8 collate utf8_bin;
alter table sources convert to character set utf8 collate utf8_bin;
alter table topic_sources convert to character set utf8 collate utf8_bin;
alter table concepts convert to character set utf8 collate utf8_bin;
alter table filters convert to character set utf8 collate utf8_bin;
alter table filter_rule_terms convert to character set utf8 collate utf8_bin;

-- Remove the 'not null' constraint from the feed tag because feed tags are added separately
alter table feeds change feed_tag feed_tag varchar(64);
