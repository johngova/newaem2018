package com.azure.aemcode.core.preprocessor;

import org.apache.felix.scr.annotations.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.replication.Preprocessor;
import com.day.cq.replication.ReplicationAction;
import com.day.cq.replication.ReplicationActionType;
import com.day.cq.replication.ReplicationException;
import com.day.cq.replication.ReplicationOptions;

@Component
public class AzurePreProcessor implements Preprocessor {

	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Override
	public void preprocess(ReplicationAction action, ReplicationOptions options) throws ReplicationException {
		
		String replicationType = action.getType().getName();
		log.debug("Replication Type: {}", replicationType);
		
		if(replicationType.equals(ReplicationActionType.ACTIVATE)) {
			
			log.debug("Asset/ Page Activated.");
			//TO-DO validations when a file is activated
			
		} else if(replicationType.equals(ReplicationActionType.DEACTIVATE)) {
			
			log.debug("Asset/ Page De-Activated.");
			//TO-DO validations when a file is deactivated
			
		}
		// TO-DO validations to be done before actual replication
	}
}
