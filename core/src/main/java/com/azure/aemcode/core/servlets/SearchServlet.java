package com.azure.aemcode.core.servlets;

import java.io.IOException;
import java.util.Arrays;
import java.util.Dictionary;
import java.util.Iterator;
import java.util.Map;

import javax.jcr.RepositoryException;
import javax.servlet.ServletException;

import org.apache.felix.scr.annotations.Activate;
import org.apache.felix.scr.annotations.Modified;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.PropertyUnbounded;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.sling.SlingServlet;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.apache.sling.commons.json.JSONException;
import org.apache.sling.commons.json.JSONObject;
import org.apache.sling.commons.osgi.PropertiesUtil;
import org.osgi.service.component.ComponentContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.azure.aemcode.core.pojo.SearchPOJO;
import com.azure.aemcode.core.search.custom.service.SearchService;
import com.day.cq.search.facets.Bucket;
import com.day.cq.search.facets.Facet;
import com.day.cq.search.result.SearchResult;

@SlingServlet(paths = { "/bin/search" }, metatype = true, methods = {
		"POST" }, generateComponent = true, generateService = true)
public class SearchServlet extends SlingAllMethodsServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2513330301331589441L;
	private static final Logger log = LoggerFactory.getLogger(SearchServlet.class);

	// if the property is used in this way--- the variable should be static and
	// final
	@Property(label = "Add Search Paths", description = "The Search will be done on the given paths only. Leaving it empty will return eempty results.", unbounded = PropertyUnbounded.ARRAY)
	private static final String PROPERTY_SEARCH_PATHS = "property.search.paths";
	
	@Reference
	SearchService searchService;

	private String[] searchPaths = null;

	@Override
	protected void doPost(SlingHttpServletRequest request, SlingHttpServletResponse response)
			throws ServletException, IOException {
		try {
			if (null == searchPaths) {
				log.debug("Taking content as search path.");
			}
			SearchPOJO searchPOJO = new SearchPOJO();
			searchPOJO.setSearchTerm(request.getParameter("search-field"));
			if (null != searchPaths)
				searchPOJO.setFilterPaths(Arrays.asList(searchPaths));
			SearchResult searchResult = searchService.getSearchResult(searchPOJO, request.getResourceResolver());
			response.getWriter().write(generateSearchResult(searchResult).toString());
		} catch (RepositoryException e) {
			log.error("Exception while getting results: ", e);
		} catch (JSONException e) {
			log.error("Exception while getting results: ", e);
		}
	}

	/**
	 * 
	 * @param searchResult
	 * @return
	 * @throws RepositoryException
	 * @throws JSONException
	 */
	private JSONObject generateSearchResult(SearchResult searchResult) throws RepositoryException, JSONException {
		JSONObject resultsJSON = new JSONObject();
		Iterator<Resource> resources = searchResult.getResources();
		while (resources.hasNext()) {
			Resource nextResource = resources.next();
			resultsJSON.put(nextResource.getName() + "*" + nextResource.getPath(), nextResource.getPath());
		}
		resultsJSON.put("facets", getFacetData(searchResult.getFacets()));
		return resultsJSON;
	}

	/**
	 * 
	 * @param facets
	 * @throws RepositoryException
	 * @throws JSONException
	 */
	private JSONObject getFacetData(Map<String, Facet> facets) throws RepositoryException, JSONException {
		JSONObject facetObject = new JSONObject();
		Iterator<String> iterator = facets.keySet().iterator();
		while (iterator.hasNext()) {
			String nextFacet = iterator.next();
			Iterator<Bucket> bucketIterator = facets.get(nextFacet).getBuckets().iterator();
			while (bucketIterator.hasNext()) {
				Bucket nextBucket = bucketIterator.next();
				facetObject.put(nextBucket.getValue(), nextBucket.getCount());
			}
		}
		return facetObject;
	}

	@SuppressWarnings("rawtypes")
	@Activate
	@Modified
	protected void activate(ComponentContext context) {
		Dictionary properties = context.getProperties();
		searchPaths = PropertiesUtil.toStringArray(properties.get(PROPERTY_SEARCH_PATHS));
	}

}
