class CatNews < ActiveRecord::Base
  validates_presence_of :date_stamp

  belongs_to :category
  belongs_to :news_item
  belongs_to :news_index
end
