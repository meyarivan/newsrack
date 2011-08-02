class Source < ActiveRecord::Base
  validates_presence_of :src_tag
  validates_length_of :src_tag, :allow_nil => false, :maximum => 256
  validates_presence_of :src_name
  validates_length_of :src_name, :allow_nil => false, :maximum => 256
  validates_inclusion_of :cacheable, :in => [true, false], :allow_nil => true, :message => ActiveRecord::Errors.default_error_messages[:blank]
  validates_inclusion_of :show_cache_links, :in => [true, false], :allow_nil => true, :message => ActiveRecord::Errors.default_error_messages[:blank]

  belongs_to :feed
  belongs_to :user

  has_many :topic_sources
  has_many :topics, :through => :topic_sources
end
