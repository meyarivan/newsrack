class RecentNewsTitleHash < ActiveRecord::Base
  validates_length_of :title_hash, :allow_nil => true, :maximum => 32

  belongs_to :news_item
end
