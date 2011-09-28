class Filter < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name, :allow_nil => false, :maximum => 256
  validates_presence_of :rule_string
  validates_numericality_of :min_match_score, :allow_nil => true, :only_integer => true

  belongs_to :user
  belongs_to :root_rule_term, :class_name => "FilterRuleTerm"

  def used_concepts
    root_rule_term.used_concepts
  end
end
