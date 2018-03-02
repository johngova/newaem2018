package com.azure.aemcode.core.service;

import org.apache.sling.api.resource.PersistenceException;
import org.apache.sling.api.resource.Resource;

/**
 * 
 *
 *
 */
public interface UpdatePropertiesUsingSling {
	public void updateProperties(Resource resource) throws PersistenceException;
}
