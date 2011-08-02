class CollectionEntry < ActiveRecord::Base
  validates_presence_of :entry_type
  validates_length_of :entry_type, :allow_nil => false, :maximum => 255

  belongs_to :collection, :class_name => "UserCollection"
  belongs_to :entry, :polymorphic => true

  # NEEDED? Explicitly list all known polymorphic associations
  # belongs_to :concept, :foreign_key => "entry_id", :class_name => "Concept"
  # belongs_to :category, :foreign_key => "entry_id", :class_name => "Category"
  # belongs_to :filter, :foreign_key => "entry_id", :class_name => "Filter"
  # belongs_to :source, :foreign_key => "entry_id", :class_name => "Source"
end
