package com.azure.aemcode.core.servlets;

import java.io.IOException;
import java.security.Principal;

import javax.jcr.RepositoryException;
import javax.jcr.security.Privilege;
import javax.servlet.ServletException;

import org.apache.commons.lang3.StringUtils;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.sling.SlingServlet;
import org.apache.jackrabbit.api.security.user.Authorizable;
import org.apache.jackrabbit.api.security.user.UserManager;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.LoginException;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.servlets.SlingSafeMethodsServlet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.azure.aemcode.core.accesscontrol.AccessControlService;

@SlingServlet(methods = {"GET"}, paths = {"/bin/setAccessControl"})
public class AccessControlServlet extends SlingSafeMethodsServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2449644833915478389L;

	@Reference
	AccessControlService accessControlService;
	
	private Logger log = LoggerFactory.getLogger(getClass());

	@Override
	protected void doGet(SlingHttpServletRequest request, SlingHttpServletResponse response)
			throws ServletException, IOException {
		String message = StringUtils.EMPTY;
		try {
			ResourceResolver resourceResolver = request.getResourceResolver();
			String parameter = request.getParameter("path");
			String userName = request.getParameter("user");
			log.debug("Path from Servlet: {}", parameter);
			if (StringUtils.isNotBlank(parameter) && StringUtils.isNotBlank(userName)
					&& (null != resourceResolver.resolve(parameter))) {
				Resource resource = resourceResolver.resolve(parameter);
				Principal userPrincipal = getUserPrincipal(userName, resourceResolver);
				String[] priviliges = new String[]{Privilege.JCR_READ, Privilege.JCR_WRITE};
				accessControlService.setAccessControl(resource, priviliges, userPrincipal);
				message = "Access Control Successfully set.";
			}
		} catch(RepositoryException e) {
			message = "Could set Acesss Control: " + e.getMessage();
			log.error("Exception during request processing.");
		} catch (LoginException e) {
			message = "Could set Acesss Control: " + e.getMessage();
			log.error("Exception during request processing.");
		}
		response.getWriter().println(message);
	}

	/**
	 * 
	 * @param userName
	 * @param resourceResolver
	 * @throws RepositoryException 
	 */
	private Principal getUserPrincipal(String userName, ResourceResolver resourceResolver) throws RepositoryException {
		UserManager userManager = resourceResolver.adaptTo(UserManager.class);
		Authorizable authorizable = userManager.getAuthorizable(userName);
		return authorizable.getPrincipal();
	}

}
