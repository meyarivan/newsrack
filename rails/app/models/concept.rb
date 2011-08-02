class Concept < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name, :allow_nil => false, :maximum => 64
  validates_presence_of :defn
  validates_presence_of :keywords
  validates_length_of :token, :allow_nil => true, :maximum => 128

  belongs_to :user
end
