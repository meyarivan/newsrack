class DownloadedNewsItem < ActiveRecord::Base
  belongs_to :feed
  belongs_to :news_item
end
