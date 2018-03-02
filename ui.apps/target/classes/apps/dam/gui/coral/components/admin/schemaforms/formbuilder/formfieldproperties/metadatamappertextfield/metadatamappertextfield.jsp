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

--%>
<%
%><%@include file="/libs/granite/ui/global.jsp" %><%
%><%@ page session="false" contentType="text/html" pageEncoding="utf-8"
           import="com.adobe.granite.ui.components.formbuilder.FormResourceManager,
         		 org.apache.sling.api.resource.Resource,
         		 org.apache.sling.api.resource.ValueMap,
                 com.adobe.granite.ui.components.Config,
                 org.apache.commons.lang.StringUtils,
         		 java.util.HashMap" %><%
    ValueMap fieldProperties = resource.adaptTo(ValueMap.class);

    Config cfg = null;

    String fieldRelativeResourcePath = (String)request.getAttribute("cq.dam.metadataschema.builder.field.relativeresource");
    if (StringUtils.isNotBlank(fieldRelativeResourcePath)) {
        Resource fieldRelativeResource = resource.getChild(fieldRelativeResourcePath);
        if (fieldRelativeResource != null) {
            cfg = new Config(fieldRelativeResource);
        }
    }
    if (cfg == null) {
        cfg = new Config(resource);
    }

    HashMap<String, Object> values = new HashMap<String, Object>();
    values.put("class",        "field-mvtext-descriptor");
    values.put("fieldLabel",   i18n.get("Map to property"));
    values.put("emptyText",    i18n.get("enter metadata key eg ./jcr:content/metadata/dc:title"));
    values.put("value",        cfg.get("name", "./jcr:content/metadata/default"));
    values.put("name", "./items/" + resource.getName() + (fieldRelativeResourcePath != null ? "/"+fieldRelativeResourcePath: "") +"/name");

    FormResourceManager formResourceManager = sling.getService(FormResourceManager.class);
    Resource labelFieldResource = formResourceManager.getDefaultPropertyFieldResource(resource, values);

%><sling:include resource="<%= labelFieldResource %>" resourceType="granite/ui/components/foundation/form/textfield"/>
