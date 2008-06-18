package newsrack.filter;

import java.util.List;
import java.util.Iterator;
import java.util.Map;
import java.util.HashMap;

import newsrack.filter.Category;
import newsrack.user.User;

public final class NR_CategoryCollection extends NR_Collection
{
	private transient Map<String, Category> _map = null;  // Name --> Category mapping .. optimization!
	private transient boolean               _allMapped = false;

	public NR_CategoryCollection(User u, String name, List entries)
	{
		super(NR_CollectionType.CATEGORY, u, name, entries);
      if (_log.isDebugEnabled()) _log.debug("RECORDED category collection with name " + name + " for user " + u.getUid());
	}

	public Category getCategory(String c)
	{
		if (_map == null)
			_map = new HashMap<String, Category>();

		Object rv = _map.get(c);
		if (rv != null) {
			return (Category)rv;
		}
		else if (_entries == null) {
				// Not in memory.  Fetch from the db!
				// Note that only top-level cats are fetched,
				// i.e. those cats whose parents are null
			Category cat = _db.getCategoryFromCollection(getKey(), c);
			if (cat != null)
				_map.put(cat.getName(), cat);
			return cat;
		}
		else if (!_allMapped) {
			for (Category cat: (List<Category>)_entries) {
				_map.put(cat.getName(), cat);
				if (cat.getName().equals(c))
					return cat;
			}
				// We have mapped all entries in the list
			_allMapped = true;
			return null;
		}
		else {
				// We have an in-memory collection and we have run through 
				// all entries in the list previously and added them to the hashmap!
			return null;
		}
	}

	public List getEntries() { return getCategories(); }

	public List getCategories()
	{
		if (_entries == null) 
			_entries = _db.getAllCategoriesFromCollection(getKey());

		return _entries;
	}
}
