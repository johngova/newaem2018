package com.azure.aemcode.core.workflows;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;

import org.apache.commons.lang3.StringUtils;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.dam.api.Asset;
import com.day.cq.dam.api.Rendition;
import com.day.cq.dam.commons.process.AbstractAssetWorkflowProcess;
import com.day.cq.workflow.WorkflowException;
import com.day.cq.workflow.WorkflowSession;
import com.day.cq.workflow.exec.WorkItem;
import com.day.cq.workflow.metadata.MetaDataMap;
import com.day.text.Text;

@Component(metatype = false)
@Service
@Property(name = "process.label", value = { "Set Last Modified - changed" })
public class TestWorkflow extends AbstractAssetWorkflowProcess {
	public static final Logger log = LoggerFactory.getLogger(TestWorkflow.class);

	public static enum Arguments {
		PROCESS_ARGS("PROCESS_ARGS"), RELATIVE_LAST_MODIFIED_PATH(
				"relativeLastModifiedPath"), RELATIVE_LAST_MODIFIED_BY_PATH("relativeLastModifiedByPath");

		private String argumentName;

		private Arguments(String argumentName) {
			this.argumentName = argumentName;
		}

		public String getArgumentName() {
			return this.argumentName;
		}

		public String getArgumentPrefix() {
			return this.argumentName + ":";
		}
	}

	public void execute(WorkItem workItem, WorkflowSession workflowSession, MetaDataMap metaData)
			throws WorkflowException {
		String[] args = buildArguments(metaData);

		Session session = workflowSession.getSession();
		Asset asset = getAssetFromPayload(workItem, session);
		if (null != asset) {
			try {
				Node assetNode = (Node) asset.adaptTo(Node.class);
				log.info("************* - Asset Node path: {}", assetNode.getPath());

				String userId = (String) workItem.getWorkflowData().getMetaDataMap().get("userId", String.class);
				log.info("User ID: {}", userId);

				Node content = assetNode.getNode("jcr:content");
				Node metadata = assetNode.getNode("jcr:content/metadata");
				String resolvedUser = userId;

				String payloadPath = null;
				if (workItem.getWorkflowData().getPayloadType().equals("JCR_PATH")) {
					payloadPath = workItem.getWorkflowData().getPayload().toString();
				}
				if (null != payloadPath) {
					Node payloadNode = session.getNode(payloadPath);
					log.info("Payload Path: {}", payloadNode.getPath());
					if (payloadNode.hasProperty("newRendition")) {
						log.info("Returning as it has newRendition.");
						return;
					}
				}
				if (content.hasProperty("newRendition")) {
					log.info("Content has newRendition.");
					Rendition rendition = asset.getRendition("original");
					if (rendition != null) {
						String lastModified = (String) rendition.getProperties().get("jcr:lastModifiedBy");
						if (StringUtils.isNotBlank(lastModified)) {
							resolvedUser = lastModified;

							content.setProperty("jcr:lastModifiedBy", resolvedUser);
							content.setProperty("jcr:lastModified", Calendar.getInstance());
						}
						return;
					}
				}
				List<String> relLastModifiedPath = getValuesFromArgs("relativeLastModifiedPath", args);
				if (relLastModifiedPath.size() > 0) {
					String nodePath = Text.getRelativeParent(
							asset.getPath() + "/" + "jcr:content" + "/" + (String) relLastModifiedPath.get(0), 1);

					Node node = (Node) session.getItem(nodePath);
					node.setProperty(Text.getName((String) relLastModifiedPath.get(0)), Calendar.getInstance());
				}
				List<String> relLastModifiedByPath = getValuesFromArgs("relativeLastModifiedByPath", args);
				if (relLastModifiedByPath.size() > 0) {
					String nodePath = Text.getRelativeParent(
							asset.getPath() + "/" + "jcr:content" + "/" + (String) relLastModifiedByPath.get(0), 1);

					Node node = (Node) session.getItem(nodePath);
					node.setProperty(Text.getName((String) relLastModifiedByPath.get(0)), resolvedUser);
				}
				content.setProperty("jcr:lastModifiedBy", resolvedUser);
				content.setProperty("jcr:lastModified", Calendar.getInstance());

				String dcModifiedPath = "jcr:content/metadata/dc:modified";
				if (!assetNode.hasProperty(dcModifiedPath)) {
					assetNode.getNode("jcr:content/metadata").setProperty("dc:modified", Calendar.getInstance());
				}
			} catch (RepositoryException e) {
				log.error("execute: repository error while setting last modified for asset [{}] in workflow ["
						+ workItem.getId() + "]", asset.getPath(), e);
			}
		}
		String wfPayload = workItem.getWorkflowData().getPayload().toString();
		String message = "execute: cannot set last modified, asset [{" + wfPayload
				+ "}] in payload doesn't exist for workflow [{" + workItem.getId() + "}].";
		throw new WorkflowException(message);
	}

	public String[] buildArguments(MetaDataMap metaData) {
		String processArgs = (String) metaData.get(Arguments.PROCESS_ARGS.name(), String.class);
		if ((processArgs != null) && (!processArgs.equals(""))) {
			return processArgs.split(",");
		}
		List<String> arguments = new ArrayList<String>();

		String relativeLastModifiedPath = (String) metaData.get(Arguments.RELATIVE_LAST_MODIFIED_PATH.name(),
				String.class);
		String relativeLastModifiedByPath = (String) metaData.get(Arguments.RELATIVE_LAST_MODIFIED_BY_PATH.name(),
				String.class);
		if (StringUtils.isNotBlank(relativeLastModifiedPath)) {
			arguments.add(Arguments.RELATIVE_LAST_MODIFIED_PATH.getArgumentPrefix() + relativeLastModifiedPath);
		}
		if (StringUtils.isNotBlank(relativeLastModifiedByPath)) {
			arguments.add(Arguments.RELATIVE_LAST_MODIFIED_BY_PATH.getArgumentPrefix() + relativeLastModifiedByPath);
		}
		return (String[]) arguments.toArray(new String[arguments.size()]);
	}
}