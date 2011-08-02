class NewsIndex < ActiveRecord::Base
  belongs_to :feed

  has_many :news_collection_entries
  has_many :news_items, :through => :news_collection_entries
end
