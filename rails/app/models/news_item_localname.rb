class NewsItemLocalname < ActiveRecord::Base
  validates_presence_of :local_file_name
  validates_length_of :local_file_name, :allow_nil => false, :maximum => 256

  belongs_to :news_item
end
