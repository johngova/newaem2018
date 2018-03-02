package com.azure.aemcode.core.service.impl;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.resource.ModifiableValueMap;
import org.apache.sling.api.resource.PersistenceException;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;

import com.azure.aemcode.core.service.UpdatePropertiesUsingSling;

/**
 * 
 * 
 *
 */
@Component(label = "AEM Code - Update Properties using Sling")
@Service(value={UpdatePropertiesUsingSling.class})
public class UpdatingPropertiesUsingSlingAPI implements UpdatePropertiesUsingSling {

	@Override
	public void updateProperties(Resource resource) throws PersistenceException {
		if(null != resource) {
			ResourceResolver resourceResolver = resource.getResourceResolver();
			
			//converting resource to modifiable value map and adding properties.
			ModifiableValueMap properties = resource.adaptTo(ModifiableValueMap.class);
			properties.put("test_property", "Hi this is test property.");
			
			if(resourceResolver.hasChanges())
				resourceResolver.commit();
		}
	}

}
