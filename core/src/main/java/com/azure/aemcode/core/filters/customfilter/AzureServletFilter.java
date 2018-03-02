package com.azure.aemcode.core.filters.customfilter;

import java.io.IOException;
import java.util.Dictionary;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.felix.scr.annotations.Activate;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Modified;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.sling.SlingFilter;
import org.apache.felix.scr.annotations.sling.SlingFilterScope;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.commons.osgi.PropertiesUtil;
import org.osgi.service.component.ComponentContext;

/**
 * 
 * 
 *
 */
@SlingFilter(scope = SlingFilterScope.REQUEST, order = 0, generateComponent = false, generateService = false)
@Component(label = "AEM-CODE Custom Sling Filter", description = "This is a custom sling filter to interrupt the servlet request processing based on resource type.", metatype = true, immediate = true)
@Service
public class AzureServletFilter implements Filter {

	@Property(label = "", description = "")
	private static final String PROPERTY_OSGI_TEST = "property.osgi.test";

	private String property_Resource_Type = "";

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// TODO Auto-generated method stub

	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		SlingHttpServletRequest slingRequest = (SlingHttpServletRequest) request;
		SlingHttpServletResponse slingResponse = (SlingHttpServletResponse) response;
		
		// TO-DO use this do-filter method to check the servlet and do the
		// processing
		if (StringUtils.isNotBlank(property_Resource_Type) && slingRequest.getResource().getResourceSuperType().equals(property_Resource_Type)) {
			// interrupt the functionality and do the processing
		}

		//for continuing the filter
		chain.doFilter(slingRequest, slingResponse);
	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

	@Activate
	@Modified
	protected void activate(ComponentContext context) {
		@SuppressWarnings("rawtypes")
		Dictionary properties = context.getProperties();
		property_Resource_Type = PropertiesUtil.toString(properties.get(PROPERTY_OSGI_TEST), "");
	}

}
