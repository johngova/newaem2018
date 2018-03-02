package com.azure.aemcode.core.servlets;

import java.io.IOException;

import javax.servlet.ServletException;

import org.apache.felix.scr.annotations.sling.SlingServlet;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingSafeMethodsServlet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * This is a Read-only servlet. For implementing the read-only servlet, the
 * class must extend SlingSafeMethodServlet which only has doGet defined in it.
 * 
 * 
 * 
 *
 */
@SlingServlet(resourceTypes = "aem-code/myresourcetype", generateComponent = true, generateService = true, extensions = { "json" }, methods = {
		"GET" })
public class AzureReadOnlySlingServlet extends SlingSafeMethodsServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5055063923292910011L;

	private Logger log = LoggerFactory.getLogger(getClass());

	@Override
	protected void doGet(SlingHttpServletRequest request, SlingHttpServletResponse response)
			throws ServletException, IOException {

		log.debug("Servlet Called.");
	}

}
