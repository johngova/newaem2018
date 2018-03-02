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
         		 com.day.cq.i18n.I18n,
         		 org.apache.sling.api.resource.Resource,
         		 org.apache.sling.api.resource.ValueMap,
         		 java.util.HashMap" %><%

    ValueMap fieldProperties = resource.adaptTo(ValueMap.class);
    String key = resource.getName();

    FormResourceManager formResourceManager = sling.getService(FormResourceManager.class);
    String orderKey = formResourceManager.getOrderKey();

    HashMap<String, Object> values = new HashMap<String, Object>();
    values.put("fieldLabel",    i18n.get("System Key"));
    values.put("emptyText",     i18n.get("system key"));
    values.put("value",         fieldProperties.get("id", String.class));
    values.put("readonly",      true);
    values.put("name",          "./items/" + resource.getName() + "/id");

    Resource systemFieldResource = formResourceManager.getDefaultPropertyFieldResource(resource, values);

%><sling:include resource="<%= systemFieldResource %>" resourceType="granite/ui/components/foundation/form/textfield"/>

<input type="hidden" name="./items/<%= key + "/" + orderKey %>"
       value="<%= fieldProperties.get(orderKey, "") %>"
       class="hidden-order">
<input type="hidden" name="./items/<%= key + "/" + orderKey %>@TypeHint" value="Long">


