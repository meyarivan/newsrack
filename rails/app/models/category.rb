class Category < ActiveRecord::Base
  validates_inclusion_of :valid, :in => [true, false], :allow_nil => true
  validates_presence_of :name
  validates_length_of :name, :allow_nil => false, :maximum => 256
  validates_numericality_of :lft, :allow_nil => true, :only_integer => true
  validates_numericality_of :rgt, :allow_nil => true, :only_integer => true
  validates_numericality_of :num_articles, :allow_nil => true, :only_integer => true
  validates_numericality_of :num_new_articles, :allow_nil => true, :only_integer => true

  belongs_to :filter
  belongs_to :topic
  belongs_to :user
  belongs_to :parent_cat, :class_name => "Category"
  has_many   :children, :class_name => "Category", :foreign_key => "parent_cat_id"
  has_many   :cat_news
  has_many   :news_items, :through => :cat_news

  def top_level?
    parent_cat.nil?
  end

  def leaf_category?
    filter.nil?
  end

  def used_concepts
    leaf_category? ? filter.used_concents : children.collect { |c| c.used_concepts }.flatten.uniq
  end
end
