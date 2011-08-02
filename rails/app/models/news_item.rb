class NewsItem < ActiveRecord::Base
  validates_presence_of :url_root
  validates_length_of :url_root, :allow_nil => false, :maximum => 128
  validates_presence_of :url_tail
  validates_length_of :url_tail, :allow_nil => false, :maximum => 256
  validates_presence_of :title

  belongs_to :primary_news_index, :class_name => "NewsIndex"
  has_one    :url_md5_hash, :class_name => "NewsItemUrlMd5Hash"
  has_many   :cat_news
  has_many   :categories, :through => :cat_news
  has_many   :news_collection_entries
  has_many   :news_indexes, :through => :news_collection_entries

  ARCHIVE_DIR = NewsRack["archive"]["root"]
  ORIG        = ARCHIVE_DIR + "/orig"
  FILT        = ARCHIVE_DIR + "/filtered"

  def relative_file_path
  end

  def filtered_file_path
  end

  def leaf_categories
  end

  def older_than(n)
    self.date <= n.date
  end
end
