class FilterRuleTerm < ActiveRecord::Base
  validates_presence_of :term_type
  validates_numericality_of :term_type, :allow_nil => false, :only_integer => true

  module FilterOp {
     NOP            = 0 
     LEAF_CONCEPT   = 1 
     AND_TERM       = 2 
     OR_TERM        = 3 
     NOT_TERM       = 4 
     CONTEXT_TERM   = 5 
     LEAF_CAT       = 6 
     LEAF_FILTER    = 7 
     PROXIMITY_TERM = 8 
     SOURCE_FILTER  = 9
  }

  belongs_to :filter
  belongs_to :arg1, :class_name => "FilterRuleTerm"
  belongs_to :arg2, :class_name => "FilterRuleTerm"

  def used_concepts
    case term_type
      when FilterOp.NOP, FilterOp.SOURCE_FILTER, FilterOp.LEAF_CAT
        []
      when FilterOp.LEAF_CONCEPT
        [arg1]
      when FilterOp.NOT_TERM, FilterOp.LEAF_FILTER
        arg1.used_concepts
      when FilterOp.AND_TERM, FilterOp.OR_TERM,  FilterOp.PROXIMITY_TERM
        arg1.used_concepts + arg2.used_concepts
      when FilterOp.CONTEXT_TERM
        [] #FIXME
    end
  end
end
