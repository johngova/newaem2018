package com.azure.aemcode.core.accesscontrol;

import java.security.Principal;

import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.UnsupportedRepositoryOperationException;
import javax.jcr.security.AccessControlEntry;
import javax.jcr.security.AccessControlException;
import javax.jcr.security.AccessControlList;
import javax.jcr.security.AccessControlManager;
import javax.jcr.security.Privilege;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.resource.LoginException;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.jcr.api.SlingRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * 
 * 
 * 	This class is used to set Access - control (creates rep:policy nodes) on the given path and 
 * 	for the given user.
 * 
 *  Note: 
 * 
 * 
 * 
 */
@Component
@Service(value = { AccessControlService.class })
public class AccessControlServiceImpl implements AccessControlService {

	@Reference
	SlingRepository repository;

	private static final Logger log = LoggerFactory.getLogger(AccessControlServiceImpl.class);

	@Override
	public void setAccessControl(Resource res, String[] privilizes, Principal userPrincipal)
			throws javax.jcr.LoginException, RepositoryException {
		Session serviceBasedSession = getSession();
		addAccessControl(res, privilizes, serviceBasedSession, userPrincipal);
	}

	/**
	 * 
	 * @param res
	 * @param privilizes
	 * @param adminSession
	 * @param userPrincipal
	 * @throws RepositoryException 
	 */
	private void addAccessControl(Resource res, String[] privilizes, Session adminSession,
			Principal userPrincipal) throws RepositoryException {
		AccessControlList accessControlList;
		AccessControlManager accessControlManager = null;
		try {
			accessControlManager = adminSession.getAccessControlManager();
			Privilege[] privileges = getAccessControlPriviliages(accessControlManager, privilizes);
			accessControlList = (AccessControlList) accessControlManager.getApplicablePolicies(res.getPath())
					.nextAccessControlPolicy();

			// removing the existing principal
			for (AccessControlEntry e : accessControlList.getAccessControlEntries())
				accessControlList.removeAccessControlEntry(e);

			// add an entry for a principal to set permissions
			accessControlList.addAccessControlEntry(userPrincipal, privileges);

			accessControlManager.setPolicy(res.getPath(), accessControlList);
			adminSession.save();
		} catch (UnsupportedRepositoryOperationException e) {
			log.error("Exception while getting AccessControlManager : " + e);
			try {
				accessControlList = (AccessControlList) accessControlManager.getPolicies(res.getPath())[0];
			} catch (RepositoryException e1) {
				log.error("Exception while getting default policies: " + e1);
			}
		} catch (RepositoryException e) {
			log.error("Exception while getting AccessControlManager : " + e);
			try {
				accessControlList = (AccessControlList) accessControlManager.getPolicies(res.getPath())[0];
				throw new RepositoryException(e.getMessage());
			} catch (RepositoryException e1) {
				log.error("Exception while getting default policies: " + e1);
			}
			throw new RepositoryException(e.getMessage());
		} finally {
			if(null != adminSession && adminSession.isLive())
				adminSession.logout();
		}
	}

	
	/**
	 * 
	 * @param accessControlManager
	 * @param privilizes
	 * @return
	 * @throws RepositoryException 
	 * @throws AccessControlException 
	 */
	private Privilege[] getAccessControlPriviliages(AccessControlManager accessControlManager, String[] privilizes) throws AccessControlException, RepositoryException {
		if(null == privilizes)
			return null;
		Privilege[] priviliages = new Privilege[privilizes.length];
		for(int i = 0; i < priviliages.length; i++){
			priviliages[i] = accessControlManager.privilegeFromName(privilizes[i]);
		}
		return priviliages;
	}

	/**
	 * @throws LoginException
	 * @throws javax.jcr.LoginException
	 * @throws RepositoryException
	 * 
	 */
	@SuppressWarnings("deprecation")
	private Session getSession() throws javax.jcr.LoginException, RepositoryException {
		return repository.loginAdministrative(null);
	}

}
