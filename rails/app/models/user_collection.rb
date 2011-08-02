class UserCollection < ActiveRecord::Base
  validates_presence_of :coll_name
  validates_length_of :coll_name, :allow_nil => false, :maximum => 64
  validates_presence_of :coll_type
  validates_length_of :coll_type, :allow_nil => false, :maximum => 3
  validates_presence_of :uid
  validates_length_of :uid, :allow_nil => false, :maximum => 32

  belongs_to :user
  belongs_to :user_file
  has_many   :collection_entries
end
