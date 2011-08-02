class UserFile < ActiveRecord::Base
  validates_presence_of :file_name
  validates_length_of :file_name, :allow_nil => false, :maximum => 256

  belongs_to :user
end
