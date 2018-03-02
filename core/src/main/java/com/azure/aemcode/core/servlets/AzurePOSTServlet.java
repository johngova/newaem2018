package com.azure.aemcode.core.servlets;

import java.io.IOException;

import javax.servlet.ServletException;

import org.apache.felix.scr.annotations.sling.SlingServlet;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * For implementing the POST servlet, the class must extend
 * SlingALLMethodsServlet which has doGet and doPost defined in it.
 * 
 * 
 *
 */
@SlingServlet(paths = {"/bin/custompostservlet"}, generateComponent = true, generateService = true)
public class AzurePOSTServlet extends SlingAllMethodsServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4807259328008084515L;
	private Logger log = LoggerFactory.getLogger(getClass());

	@Override
	protected void doPost(SlingHttpServletRequest request, SlingHttpServletResponse response)
			throws ServletException, IOException {
		log.debug("Sling POST Method.");
	}

	@Override
	protected void doGet(SlingHttpServletRequest request, SlingHttpServletResponse response)
			throws ServletException, IOException {
		log.debug("Sling GET Method.");
	}

}
