<%--

  ADOBE CONFIDENTIAL
  __________________

   Copyright 2012 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.

--%><%
%><%@include file="/libs/granite/ui/global.jsp" %><%
%><%@ page session="false" contentType="text/html" pageEncoding="utf-8"
         import="com.adobe.granite.ui.components.formbuilder.FormResourceManager,
         		 org.apache.sling.api.resource.Resource,
                 org.apache.sling.api.resource.ResourceResolver,
				 org.apache.sling.api.resource.SyntheticResource,
                 org.apache.sling.api.resource.ResourceWrapper,
                 org.apache.sling.api.wrappers.ValueMapDecorator,
         		 org.apache.sling.api.resource.ValueMap,
                 com.adobe.granite.ui.components.Config,
		  		 java.util.HashMap,
                 java.util.Map,

                 java.util.Collections"%><%

    ValueMap fieldProperties = resource.adaptTo(ValueMap.class);
    Config cfg = new Config(resource);
//    String[] val = cfg.get("default", String[].class);
    String[] val = cfg.get("value", String[].class);
    StringBuilder sb = new StringBuilder();

    HashMap<String, Object> values = new HashMap<String, Object>();
    values.put("class",        "field-default-descriptor default-tags-descriptor");
    values.put("fieldLabel",   i18n.get("Default Value"));
    values.put("emptyText",    cfg.get("emptyText", i18n.get("default value")));
    values.put("value",        cfg.get("value", String.class));
    values.put("name",         "./items/" + resource.getName() + "/value");
    values.put("multiple",     true);
    if (val !=null) {
        for (int i = 0; i < val.length; i++) {
            sb.append(val[i]);
            if (i < val.length - 1)
                sb.append(",");
        }
    }
            values.put("default", sb.toString());

//values.put("default", cfg.get("default", String[].class));

    FormResourceManager formResourceManager = sling.getService(FormResourceManager.class);
    Resource defaultTagFieldResource = formResourceManager.getDefaultPropertyFieldResource(resource, values);
    ParentSyntheticResource wrappedResource = new ParentSyntheticResource(defaultTagFieldResource);
    String tagFieldResPath = defaultTagFieldResource.getPath();
    String datasourceResPath = tagFieldResPath + "/datasource";
    Resource datasourceResource = new SyntheticResourceExtension(resourceResolver, datasourceResPath, "cq/gui/components/common/datasources/tags" );
    wrappedResource.addChild("datasource",datasourceResource);

    String optionsResPath = tagFieldResPath + "/options";
    Resource optionsResource = new SyntheticResourceExtension(resourceResolver, optionsResPath, "granite/ui/components/foundation/form/autocomplete/list" );
    wrappedResource.addChild("options",optionsResource);

    String valuesResPath = tagFieldResPath + "/values";
    Resource valuesResource = new SyntheticResourceExtension(resourceResolver, valuesResPath, "granite/ui/components/foundation/form/autocomplete/tags" );
    wrappedResource.addChild("values",valuesResource);


%><sling:include resource="<%= wrappedResource %>" resourceType="granite/ui/components/foundation/form/autocomplete"/>
<%!
private class ParentSyntheticResource extends ResourceWrapper {
    HashMap<String, Resource> childMap;
    Resource parentRes;
    public ParentSyntheticResource(Resource wrappedResource) {
        this(wrappedResource, null);
    }

    public ParentSyntheticResource(Resource wrappedResource, Resource parent) {
        super(wrappedResource);
        parentRes = parent;
        childMap = new HashMap<String, Resource>();
    }

    public void addChild(String relPath, Resource child) {
        childMap.put(relPath, new ParentSyntheticResource(child, this));
    }

    public Resource getChild(String relPath) {
    	return childMap.get(relPath);
    }

    public Resource getParent() {
        return (parentRes != null)? parentRes: super.getParent();
    }
};

public class SyntheticResourceExtension extends SyntheticResource {

    private ValueMap fieldValueMap;

    public SyntheticResourceExtension(ResourceResolver resourceResolver, String path, String resourceType) {
        super(resourceResolver, path, resourceType);
		Map map = Collections.singletonMap("sling:resourceType", resourceType);
        fieldValueMap = new ValueMapDecorator(map);
    }

    @SuppressWarnings("unchecked")
    @Override
    public <AdapterType> AdapterType adaptTo(Class<AdapterType> type) {

        // Return ValueMap of resource Meta
        if (type == ValueMap.class) {
            return (AdapterType) this.fieldValueMap;
        }
        return super.adaptTo(type);
    }

}
%>
