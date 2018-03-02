package com.azure.aemcode.core.accesscontrol;

import java.security.Principal;

import javax.jcr.RepositoryException;

import org.apache.sling.api.resource.LoginException;
import org.apache.sling.api.resource.Resource;

public interface AccessControlService {
	public void setAccessControl(Resource res, String[] priviliges, Principal userPrincipal) throws LoginException, javax.jcr.LoginException, RepositoryException;
}
