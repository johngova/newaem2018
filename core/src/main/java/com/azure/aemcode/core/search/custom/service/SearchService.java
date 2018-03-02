package com.azure.aemcode.core.search.custom.service;

import org.apache.sling.api.resource.ResourceResolver;

import com.azure.aemcode.core.pojo.SearchPOJO;
import com.day.cq.search.result.SearchResult;

/**
 * 
 *
 *
 */
public interface SearchService {
	public SearchResult getSearchResult(SearchPOJO pojo, ResourceResolver resolver);
}
