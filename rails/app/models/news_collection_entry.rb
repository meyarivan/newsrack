class NewsCollectionEntry < ActiveRecord::Base
  belongs_to :feed
  belongs_to :news_index  
  belongs_to :news_item
end
