class Feed < ActiveRecord::Base
  validates_length_of :feed_tag, :allow_nil => true, :maximum => 64
  validates_presence_of :feed_name
  validates_length_of :feed_name, :allow_nil => false, :maximum => 128
  validates_presence_of :url
  validates_length_of :url, :allow_nil => false, :maximum => 2048
  validates_inclusion_of :cacheable, :in => [true, false], :allow_nil => true, :message => ActiveRecord::Errors.default_error_messages[:blank]
  validates_inclusion_of :use_ignore_comments_heuristic, :in => [true, false], :allow_nil => true, :message => ActiveRecord::Errors.default_error_messages[:blank]
  validates_inclusion_of :show_cache_links, :in => [true, false], :allow_nil => true, :message => ActiveRecord::Errors.default_error_messages[:blank]
  validates_numericality_of :mins_between_downloads, :allow_nil => true, :only_integer => true
  validates_numericality_of :num_fetches, :allow_nil => true, :only_integer => true
  validates_numericality_of :num_failures, :allow_nil => true, :only_integer => true
  validates_inclusion_of :dead, :in => [true, false], :allow_nil => true, :message => ActiveRecord::Errors.default_error_messages[:blank]
  validates_length_of :publication, :allow_nil => true, :maximum => 255
  validates_uniqueness_of :feed_tag

  has_many :downloaded_news_items
  has_many :news_indexes
  has_many :sources
  has_many :news_collection_entries  # This table is unnormalized for direct access to feed_id instead of going through news_index
  has_many :topic_sources  # This table is unnormalized for direct access to feed_id instead of going through source
end
