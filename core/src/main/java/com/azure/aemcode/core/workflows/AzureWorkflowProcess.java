package com.azure.aemcode.core.workflows;

import java.util.Iterator;
import java.util.List;

import javax.jcr.Session;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.dam.api.Asset;
import com.day.cq.dam.commons.process.AbstractAssetWorkflowProcess;
import com.day.cq.workflow.WorkflowException;
import com.day.cq.workflow.WorkflowSession;
import com.day.cq.workflow.exec.Route;
import com.day.cq.workflow.exec.WorkItem;
import com.day.cq.workflow.exec.WorkflowProcess;
import com.day.cq.workflow.metadata.MetaDataMap;

/**
 * 
 * For Workflows we can either implement the WorkflowProcess or Extend
 * AbstractWorkflowProcess. AbstractWorkflowProcess - used to get the asset
 * directly from the item.
 * 
 * Note: No need to save the session in Workflow.
 * 
 *
 */
@Component(name = "AEM Code - Custom Workflow Process")
@Service
@Properties({ @Property(name = "process.label", value = "AEM Code - Custom Workflow Process", propertyPrivate = true) })
public class AzureWorkflowProcess extends AbstractAssetWorkflowProcess implements WorkflowProcess {

	private Logger log = LoggerFactory.getLogger(getClass());

	@Override
	public void execute(WorkItem item, WorkflowSession session, MetaDataMap metadataMap) throws WorkflowException {

		// getting the JCR session from workflow-session. Admin session will be
		// returned from workflow session.
		Session jcrSession = session.getSession();
		log.debug("Workflow User : {}", jcrSession.getUserID());

		// getting the payload.
		String payload = (String) item.getWorkflowData().getPayload();
		log.debug("Payload: {}", payload);

		// getting the asset directly from payload. For this we have to extend
		// AbstractAssetWorkflowProcess.
		Asset assetFromPayload = getAssetFromPayload(item, jcrSession);
		log.debug("Asset Path: {}", assetFromPayload.getPath());

		// for passing values between workflow steps get the workflow metadata
		// map from item and put the values. For persisting those values on
		// metadata node use session.updateWorkflowData. otherwise, this is not
		// needed.
		MetaDataMap workflowData = item.getWorkflowData().getMetaDataMap();
		workflowData.put("test", "test-value");
		session.updateWorkflowData(item.getWorkflow(), item.getWorkflowData());
		
		//for getting all workItems of workflow
		List<WorkItem> workItems = item.getWorkflow().getWorkItems();
		Iterator<WorkItem> iterator = workItems.iterator();
		while(iterator.hasNext()){
			log.debug("WorkItem: {}", iterator.next().getId());
		}

		// to get all the routes and skip step
		List<Route> routes = session.getRoutes(item);
		Iterator<Route> iterator2 = routes.iterator();
		while (iterator2.hasNext()) {
			Route next = iterator2.next();
			if(next.getId().equals(item.getId())) {
				
				//for skipping the particular workflow item
				session.complete(item, next);
			}
		}
	}

}
