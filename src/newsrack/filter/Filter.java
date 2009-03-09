package newsrack.filter;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import newsrack.database.NewsItem;
import newsrack.util.StringUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class Filter implements java.io.Serializable
{
// ############### STATIC FIELDS AND METHODS ############
	        static       short      MIN_REQD_MATCH_COUNT = 2;
	private static final short      AND_TERM_MIN_MATCH   = 3;
	private static       String     _indent              = "";
	private static final FilterOp[] _termTypes;
	private static final HashMap<FilterOp, Integer> _typeMap = new HashMap<FilterOp, Integer>();

	public static enum FilterOp { NOP, LEAF_CONCEPT, AND_TERM, OR_TERM, NOT_TERM, CONTEXT_TERM, LEAF_CAT, LEAF_FILTER, TILDE_TERM };

	public static FilterOp getTermType(int n) { return _termTypes[n]; }
	public static int      getValue(FilterOp op) { return _typeMap.get(op); }

   private static Log _log = LogFactory.getLog(Filter.class);

	static { 
		_termTypes = FilterOp.values(); 
		for (int i = 0; i < _termTypes.length; i++)
			_typeMap.put(_termTypes[i], i);
	}

// ############### NON-STATIC FIELDS AND METHODS ############
					 Long     _key;				// unique db key
	public final String   _name;				// Filter name
	public final String 	 _ruleString;		// Rule - as a string
	public final RuleTerm _rule;				// Rule - as an expression tree

	public Filter(String name, String ruleString, RuleTerm r) { _name = name; _rule = r; _ruleString = ruleString; } 
	public Filter(String name, RuleTerm r) { _name = name; _rule = r; _ruleString = r.toString(); }
	public void setKey(Long k)    { _key = k; }
	public Long getKey()          { return _key; }
	public String getName()       { return _name; }
	public RuleTerm getRule()     { return _rule; }
	public String getRuleString() { return _ruleString; }

	public int getMatchCount(NewsItem article, int numTokens, Hashtable matchCounts)
	{
		try {
			return _rule.getMatchCount(article, numTokens, matchCounts); 
		}
		catch (Exception e) {
			_log.error("Caught exception in match count for filter: " + _key + ": " + _ruleString, e);
			return 0;
		}
	}

	public void  collectUsedConcepts(Set<Concept> concepts) { _rule.collectUsedConcepts(concepts); } 

// ############### NESTED CLASSES ############

	/* class RuleTerm is a tree-node in the parse tree
	 * representing a category matching rule 
	 * The term could be 
	 *   - a leaf-concept term
	 *   - a leaf-filter term
	 *   - a leaf-category term
	 *   - a leaf-negation term
	 *   - a context-sensitive concept term
	 *   - a non-leaf AND term
	 *   - a non-leaf OR term
	 */
	public static abstract class RuleTerm implements java.io.Serializable
	{
		abstract public FilterOp getType();
		abstract public Object   getOperand1();
		abstract public Object   getOperand2();
		abstract public String   toString();
		abstract public void     print(PrintWriter pw);
		abstract public void     collectUsedConcepts(Set<Concept> usedConcepts);
		abstract public int      getMatchCount(NewsItem article, int numTokens, Hashtable matchCounts);
	}

	/* class LeafConcept encodes a leaf concept */
	public static class LeafConcept extends RuleTerm
	{
		private Concept _concept;
		private int     _minOccurences;	// Default is 1

		public LeafConcept(Concept c) { _concept = c; _minOccurences = 1; }
		public LeafConcept(Concept c, Integer minOccurences) { _concept = c; _minOccurences = (minOccurences == null) ? 1 : minOccurences; }
		public FilterOp getType()     { return FilterOp.LEAF_CONCEPT; }
		public Object getOperand1()   { return _concept; }
		public Object getOperand2()   { return null; }
		public int getMinOccurences() { return _minOccurences; }
		public String toString()      { return _concept.getName() + (_minOccurences == 1 ? "" : ":" + _minOccurences); }
		public void print(PrintWriter pw) { pw.println(_indent + _concept.getLexerToken().getToken() + (_minOccurences == 1 ? "" : ":" + _minOccurences)); }
		public void collectUsedConcepts(final Set<Concept> usedConcepts) { usedConcepts.add(_concept); }

		public int getMatchCount(NewsItem article, int numTokens, Hashtable matchCounts)
		{
			final Count mc    = (Count)matchCounts.get(_concept.getLexerToken().getToken());
			final int   count = ((mc == null) ? 0 : mc.value());
			return count >= _minOccurences ? count : 0;
		}
	}

	/* class LeafFilter encodes a leaf filter */
	public static class LeafFilter extends RuleTerm
	{
		private Filter _filt;

		public LeafFilter(final Filter f) { _filt = f; }
		public FilterOp getType()   { return FilterOp.LEAF_FILTER; }
		public Object getOperand1() { return _filt; }
		public Object getOperand2() { return null; }
		public String toString()    { return "[" + _filt.getName() + "]"; }
		public void print(PrintWriter pw) { pw.println(_indent + _filt.getName()); }
		public void collectUsedConcepts(final Set<Concept> usedConcepts) { _filt.collectUsedConcepts(usedConcepts); }
		public int getMatchCount(NewsItem article, int numTokens, Hashtable matchCounts) { return _filt.getMatchCount(article, numTokens, matchCounts); }
	}

	/* class LeafCategory encodes a leaf category */
	public static class LeafCategory extends RuleTerm
	{
		private Category _cat;

		public LeafCategory(final Category c) { _cat = c; }
		public FilterOp getType()   { return FilterOp.LEAF_CAT; }
		public Object getOperand1() { return _cat; }
		public Object getOperand2() { return null; }
		public String toString()    { return "[" + _cat.getName() + "]"; }
		public void print(PrintWriter pw) { pw.println(_indent + _cat.getName()); }
		public void collectUsedConcepts(Set<Concept> usedConcepts) { }

		public int getMatchCount(NewsItem article, int numTokens, Hashtable matchCounts)
		{
				// FIXME: Use hashcode instead!
			Count mc = (Count)matchCounts.get("[" + _cat.getName() + "]");
			if (mc == null) {
				if (_log.isDebugEnabled()) _log.debug("CAT " + _cat.getName() + " in issue " + _cat.getIssue().getName() + " being processed recursively!");
				mc = _cat.getMatchCount(article, numTokens, matchCounts);
			}
			return mc.value();
		}
	}

	/* class ContextTerm encodes a context-sensitive
	 * concept term. */
	public static class ContextTerm extends RuleTerm
	{
		private List     _context;
		private RuleTerm _r;

		public ContextTerm(final RuleTerm r, final List context) { _r = r; _context = new ArrayList(); _context.addAll(context); }
		public FilterOp getType()   { return FilterOp.CONTEXT_TERM; }
		public Object getOperand1() { return _r; }
		public Object getOperand2() { return _context; }

		public String toString()
		{
			final StringBuffer b = new StringBuffer();
			final Iterator it = _context.iterator();
			b.append("|" + ((Concept)it.next()).getName());
			while (it.hasNext())
				b.append(", " + ((Concept)it.next()).getName());
			b.append("|." + _r.toString());
			return b.toString();
		}

		public void print(PrintWriter pw)
		{
			pw.println(_indent);
			final Iterator it = _context.iterator();
			pw.print(it.next());
			while (it.hasNext())
				pw.print(", " + it.next());
			pw.print(".");
			_r.print(pw);
		}

		public void collectUsedConcepts(final Set<Concept> usedConcepts)
		{
			final Iterator it = _context.iterator();
			while (it.hasNext()) {
				final Concept c = (Concept)it.next();
				usedConcepts.add(c);
			}
			_r.collectUsedConcepts(usedConcepts);
		}

		public int getMatchCount(NewsItem article, int numTokens, Hashtable matchCounts)
		{
				// First, check if the context matches
			boolean contextMatched = false;
			final Iterator it = _context.iterator();
			while (it.hasNext()) {
				final Concept c = (Concept)it.next();
				if (matchCounts.get(c.getLexerToken().getToken()) != null) {
					contextMatched = true;
					break;
				}
			}

			if (!contextMatched)
				return 0;

			return _r.getMatchCount(article, numTokens, matchCounts);
		}
	}

	/* class NegConcept encodes a negation of a concept */
	public static class NegTerm extends RuleTerm
	{
		private RuleTerm _t;

		public NegTerm(final RuleTerm t) { _t = t; }
		public FilterOp getType()   { return FilterOp.NOT_TERM; }
		public Object getOperand1() { return _t; }
		public Object getOperand2() { return null; }
		public String toString()    { return "-" + _t.toString(); }
		public void print(PrintWriter pw) { pw.println(_indent + "-" + _t); }
		public void collectUsedConcepts(final Set<Concept> usedConcepts) { _t.collectUsedConcepts(usedConcepts); }

		public int getMatchCount(NewsItem article, int numTokens, Hashtable matchCounts)
		{
			final int count = (MIN_REQD_MATCH_COUNT - _t.getMatchCount(article, numTokens, matchCounts));
			return (count > 0) ? count : 0;
		}
	}

	/* class AndOrTerm encodes an AND/OR expression */
	public static class AndOrTerm extends RuleTerm
	{
		private FilterOp 	_op;		// AND / OR?
		private RuleTerm  _lTerm;	// Left term
		private RuleTerm  _rTerm;	// Right term

		public AndOrTerm(final FilterOp op, final RuleTerm lt, final RuleTerm rt) { _op  = op; _lTerm = lt; _rTerm = rt; }
		public FilterOp getType()   { return _op; }
		public Object getOperand1() { return _lTerm; }
		public Object getOperand2() { return _rTerm; }
		public String toString()    { return "(" + _lTerm.toString() + ((_op == FilterOp.AND_TERM) ? " AND " : " OR ") + _rTerm.toString() + ")"; }

		public void print(PrintWriter pw)
		{
			final String old = _indent;
			_indent = old + StringUtils.TAB;

			if (_op == FilterOp.AND_TERM)
				pw.println(old + " AND ");
			else
				pw.println(old + " OR ");
			_lTerm.print(pw);
			_rTerm.print(pw);

			_indent = old;
		}

		public void collectUsedConcepts(final Set<Concept> usedConcepts)
		{
			_lTerm.collectUsedConcepts(usedConcepts);
			_rTerm.collectUsedConcepts(usedConcepts);
		}

		public int getMatchCount(NewsItem article, int numTokens, Hashtable matchCounts)
		{
			final int ltCount = _lTerm.getMatchCount(article, numTokens, matchCounts);
			final int rtCount = _rTerm.getMatchCount(article, numTokens, matchCounts);
			if (_op == FilterOp.AND_TERM) {
				if ((ltCount == 0) || (rtCount == 0))
					return 0;
				else if ((ltCount > AND_TERM_MIN_MATCH) && (rtCount > AND_TERM_MIN_MATCH))
					return (ltCount + rtCount)/2;
				else
					return ((ltCount < rtCount) ? ltCount : rtCount);
			} 
			else {
				return ltCount + rtCount;
			}
		}
	}

/*
 * Not yet supported!  Requires me to change the rule term table because this rule term has 3 args, c1, c2 and proximityVal
 * The interface for RuleTerm also need changing
 *
	public static class TildeTerm extends RuleTerm
	{
		private Concept _c1;
		private Concept _c2;
		private int     _proximityVal;

		public FilterOp getType()   { return FilterOp.TILDE_TERM; }
		public Object getOperand1() { return _c1; }
		public Object getOperand2() { return _c2; }
		public String toString()    { return _c1.getName() + " ~" + _proximityVal + " " + _c2.getName(); }
		public void print(PrintWriter pw) { TODO }
		public void collectUsedConcepts(final Set<Concept> usedConcepts) { usedConcepts.add(_c1); usedConcepts.add(_c2); }
		public int getMatchCount(NewsItem article, int numTokens, Hashtable matchCounts) { TODO }
	}
*/
}
