class NewsItemUrlMd5Hash < ActiveRecord::Base
  validates_presence_of :url_hash
  validates_length_of :url_hash, :allow_nil => false, :maximum => 32

  belongs_to :news_item
end
