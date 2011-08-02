class Tag < ActiveRecord::Base
  validates_numericality_of :tag_key, :allow_nil => true, :only_integer => true
  validates_length_of :taggable_type, :allow_nil => true, :maximum => 16
end
