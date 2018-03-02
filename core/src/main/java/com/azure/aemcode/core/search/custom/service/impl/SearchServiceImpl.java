package com.azure.aemcode.core.search.custom.service.impl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.jcr.Session;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.resource.ResourceResolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.azure.aemcode.core.pojo.SearchPOJO;
import com.azure.aemcode.core.search.custom.service.SearchService;
import com.day.cq.search.PredicateGroup;
import com.day.cq.search.Query;
import com.day.cq.search.QueryBuilder;
import com.day.cq.search.result.SearchResult;

/**
 * 
 *
 *
 */
@Component
@Service(value = { SearchService.class })
public class SearchServiceImpl implements SearchService {

	private Logger log = LoggerFactory.getLogger(getClass());
	@Override
	public SearchResult getSearchResult(SearchPOJO searchAttributes, ResourceResolver resolver) {
		Map<String, String> predicateMap = getSearchPredicateMap(searchAttributes, resolver);
		return executeQuery(predicateMap, resolver);
	}

	/**
	 * 
	 * @param predicateMap
	 * @param resolver
	 * @return
	 */
	private SearchResult executeQuery(Map<String, String> predicateMap, ResourceResolver resolver) {
		QueryBuilder queryBuilder = resolver.adaptTo(QueryBuilder.class);
		Query query = queryBuilder.createQuery(PredicateGroup.create(predicateMap), resolver.adaptTo(Session.class));
		SearchResult searchResult = query.getResult();
		return searchResult;
	}

	/**
	 * 
	 * @param searchAttributes
	 * @param resolver
	 * @return
	 */
	private Map<String, String> getSearchPredicateMap(SearchPOJO searchAttributes, ResourceResolver resolver) {
		Map<String, String> predMap = new HashMap<String, String>();
		List<String> filterPaths = searchAttributes.getFilterPaths();

		// basic attributes
		predMap.put("fulltext", searchAttributes.getSearchTerm());
		//predMap.put("type", "cq:Page");

		// for running query on single path. Multiple paths is given below with
		// grouping.
		// predMap.put("path", "");

		if (searchAttributes.getFilterPaths().isEmpty()) {
			predMap.put("path", "/content");
		} else {
			
			// below code is for grouping with or condition. If and is needed
			// don't
			// give the below line.
			predMap.put("1_group_p.or", "true");

			// for running query in different paths
			Iterator<String> iterator = filterPaths.iterator();
			int i = 0;
			while (iterator.hasNext()) {
				predMap.put("1_group." + (i + 1) + "path", iterator.next());
				i++;
			}
		}

		// The below are used for pagination::
		//
		// change the limit if all the results are not required. -1 will return
		// all results.
		predMap.put("p.limit", "-1");
		// guess total is for getting partial results. This should be used with
		// predicate - 'p.offset' to get the results from the offset value
		// predMap.put("p.guessTotal", "true");

		// the results will start from the offset specified. For ex: if offset
		// is 10 and limit is 10, results will start from 11th result till 20th
		// result.
		// predMap.put("p.offset", "0");
		
		//for adding custom predicate facet -- we have add the predicate in query-builder
		//for adding custom predicate filter -- we have add the predicate in query-builder
		predMap.put("searchFacet", "true");
		predMap.put("searchFilter", "true");
		
		

		// sorting and order by
		predMap.put("orderby", "@jcr:score");
		predMap.put("orderby.sort", "desc");

		return predMap;
	}
}