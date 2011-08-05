class User < ActiveRecord::Base
  validates_presence_of :uid
  validates_length_of :uid, :allow_nil => false, :maximum => 32
  validates_presence_of :password
  validates_length_of :password, :allow_nil => false, :maximum => 32
  validates_presence_of :name
  validates_length_of :name, :allow_nil => false, :maximum => 256
  validates_presence_of :email
  validates_length_of :email, :allow_nil => false, :maximum => 256
  validates_inclusion_of :validated, :in => [true, false], :allow_nil => true
  validates_presence_of :last_login
  validates_uniqueness_of :uid

  has_many :user_files
  has_many :user_collections
  has_many :topics

  has_many :concepts
  has_many :categories
  has_many :filters
  has_many :sources
end
