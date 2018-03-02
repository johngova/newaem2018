package com.azure.aemcode.core.search.custom.predicate.facet;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.jcr.Node;
import javax.jcr.RepositoryException;

import org.apache.commons.lang3.StringUtils;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.search.Predicate;
import com.day.cq.search.eval.AbstractPredicateEvaluator;
import com.day.cq.search.eval.EvaluationContext;
import com.day.cq.search.facets.Facet;
import com.day.cq.search.facets.FacetExtractor;
import com.day.cq.search.facets.buckets.SimpleBucket;
import com.day.cq.search.facets.extractors.FacetImpl;

/**
 * Facets - facets are nothing but categories, search results can be divided
 * into different categories based on the different criteria. The Method
 * "handleNode" is used to filter the results into different facets
 * (Categories).
 * 
 *
 *
 */
@Component(factory = "com.day.cq.search.eval.PredicateEvaluator/searchFacet")
@Service
public class PredicateEvaluatorFacet extends AbstractPredicateEvaluator {
	
	private Logger log = LoggerFactory.getLogger(getClass());

	@Override
	public FacetExtractor getFacetExtractor(Predicate predicate, EvaluationContext context) {
		return new CustomFacetExtractor(predicate, context);
	}

	@SuppressWarnings("unused")
	class CustomFacetExtractor implements FacetExtractor {

		private Map<String, SimpleBucket> bucketMap = new HashMap<String, SimpleBucket>();
		private String langPath = StringUtils.EMPTY;
		EvaluationContext context;

		public CustomFacetExtractor(Predicate predicate, EvaluationContext context) {
			this.context = context;

			// categories should be stored in a map. Here the map is made null,
			// but categories should be added to this map in order to add map
			// the results to different categories.
			
			// The bucket map should be incremented based on the category. This
			// will give count of each category.
			Map<String, String> categoryMap = new HashMap<String, String>();
			categoryMap.put("Pages", "Pages");
			categoryMap.put("Assets", "Assets");
			categoryMap.put("Tags", "Tags");
			
			if (null != categoryMap && categoryMap.size() >= 1) {
				Iterator<String> iterator = categoryMap.keySet().iterator();
				while (iterator.hasNext()) {
					String category = iterator.next();
					log.debug("Processing category: {}", category);
					bucketMap.put(category, new SimpleBucket(predicate, category));
				}
			}
		}

		@Override
		public Facet getFacet() {
			if (bucketMap.size() == 0) {
				return null;
			}
			return new FacetImpl(bucketMap.values());
		}

		@Override
		public void handleNode(Node node) throws RepositoryException {
			
			if(node.getPath().startsWith("/content/dam")) {
				bucketMap.get("Assets").increment();
			} else if(node.getPath().startsWith("/etc/tags")) {
				bucketMap.get("Tags").increment();
			} else if(node.getPath().startsWith("/content") && !node.getPath().startsWith("/content/dam")) {
				bucketMap.get("Pages").increment();
			}
		}

	}
}
