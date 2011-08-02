class Topic < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name, :allow_nil => false, :maximum => 256
  validates_numericality_of :num_articles, :allow_nil => true, :only_integer => true
  validates_presence_of :last_update
  validates_inclusion_of :validated, :in => [true, false], :allow_nil => true, :message => ActiveRecord::Errors.default_error_messages[:blank]
  validates_inclusion_of :frozen, :in => [true, false], :allow_nil => true, :message => ActiveRecord::Errors.default_error_messages[:blank]
  validates_inclusion_of :private, :in => [true, false], :allow_nil => true, :message => ActiveRecord::Errors.default_error_messages[:blank]
  validates_numericality_of :num_new_articles, :allow_nil => true, :only_integer => true

  belongs_to :user
  has_many :categories
  has_many :topic_sources
  has_many :sources, :through => :topic_sources
end
