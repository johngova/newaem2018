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
         		 org.apache.sling.api.resource.ValueMap,
                 org.apache.commons.lang.StringUtils,
                 com.adobe.granite.ui.components.Config,
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
    values.put("class",     "checkbox-label required");
    values.put("text",      i18n.get("Required"));
    values.put("value",     cfg.get("required", false));
    values.put("checked",   cfg.get("required", false));
    values.put("name", "./items/" + resource.getName() + (fieldRelativeResourcePath != null ? "/"+fieldRelativeResourcePath: "") +"/required");

    FormResourceManager formResourceManager = sling.getService(FormResourceManager.class);
    Resource placeholderFieldResource = formResourceManager.getDefaultPropertyFieldResource(resource, values);

%><sling:include resource="<%= placeholderFieldResource %>" resourceType="granite/ui/components/foundation/form/checkbox"/>

<input type="hidden" name="./items/<%= resource.getName() %>/required@Delete" value="true">
<input type="hidden" name="./items/<%= resource.getName() %>/required@TypeHint" value="Boolean">

