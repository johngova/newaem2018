package com.azure.aemcode.core.search.custom.predicate.filter;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Dictionary;
import java.util.Iterator;
import java.util.List;

import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.query.Row;

import org.apache.felix.scr.annotations.Activate;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Modified;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.PropertyUnbounded;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.commons.osgi.PropertiesUtil;
import org.osgi.service.component.ComponentContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.search.Predicate;
import com.day.cq.search.eval.AbstractPredicateEvaluator;
import com.day.cq.search.eval.EvaluationContext;
import com.day.cq.search.facets.FacetExtractor;

/**
 * 
 * canXpath - return 'true' if xpath expression is to be included. canFilter -
 * return 'true' if filtering is needed. Use "includes" method to filter the
 * nodes based on the requirement.
 * 
 *
 *
 */

@Component(factory = "com.day.cq.search.eval.PredicateEvaluator/searchFilter")
@Service
public class SearchPredicateEvaluatorFilter extends AbstractPredicateEvaluator {

	private Logger log = LoggerFactory.getLogger(getClass());
	
	@Property(label = "Add blocked Search Paths", description = "The Search will not happen on the given paths.", unbounded = PropertyUnbounded.ARRAY)
	private static final String PROPERTY_BLOCKED_SEARCH_PATHS = "property.search.blocked.paths";

	private String[] blockedPaths = null;
	private List<String> asList = new ArrayList<String>();

	@Override
	public boolean canXpath(Predicate predicate, EvaluationContext context) {
		return false;
	}

	@Override
	public boolean canFilter(Predicate predicate, EvaluationContext context) {
		return true;
	}

	@Override
	public boolean includes(Predicate predicate, Row row, EvaluationContext context) {

		// checks for property values and return true (includes the node in
		// final result)
		try {
			Node node = row.getNode();
			if (node.hasProperty("jcr:primaryType")) {
				String propertyValue = node.getProperty("jcr:primaryType").getString();
				if ((propertyValue.equals("cq:Page") || propertyValue.equals("cq:Tag")
						|| propertyValue.equals("dam:Asset")) && isAllowedType(node)) {
					return true;
				} else {
					return false;
				}
			}
		} catch (RepositoryException e) {
			log.error("Error in custom predicate filter: ", e);
		}
		return false;
	}

	/**
	 * 
	 * @param node
	 * @return
	 * @throws RepositoryException
	 */
	private boolean isAllowedType(Node node) throws RepositoryException {
		String nodePath = node.getPath();
		if ((nodePath.startsWith("/content") || nodePath.startsWith("/content/dam") || nodePath.startsWith("/etc/tags"))
				&& !(!asList.isEmpty() && isContainsPath(asList, nodePath))) {
			return true;
		}
		return false;
	}

	
	private boolean isContainsPath(List<String> asList, String nodePath) {
		Iterator<String> iterator = asList.iterator();
		while(iterator.hasNext()) {
			return nodePath.startsWith(iterator.next());
		}
		return false;
	}

	@Override
	public FacetExtractor getFacetExtractor(Predicate predicate, EvaluationContext context) {
		return super.getFacetExtractor(predicate, context);
	}

	@Override
	public String getXPathExpression(Predicate predicate, EvaluationContext context) {
		return super.getXPathExpression(predicate, context);
	}

	@SuppressWarnings("deprecation")
	@Override
	public boolean isFiltering(Predicate predicate, EvaluationContext context) {
		return super.isFiltering(predicate, context);
	}
	
	@SuppressWarnings("rawtypes")
	@Activate
	@Modified
	protected void activate(ComponentContext context) {
		Dictionary properties = context.getProperties();
		blockedPaths = PropertiesUtil.toStringArray(properties.get(PROPERTY_BLOCKED_SEARCH_PATHS));
		if (null == blockedPaths)
			blockedPaths = new String[] { "/content/campaigns", "/content/communities", "/content/phonegap",
					"/content/community-components", "/content/catalogs", "/content/forms", "/content/mobileapps",
					"/content/screens" };
		asList.addAll(Arrays.asList(blockedPaths));
	}
}
