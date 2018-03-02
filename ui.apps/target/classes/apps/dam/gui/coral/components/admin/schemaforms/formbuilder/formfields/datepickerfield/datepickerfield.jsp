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
         		 org.apache.sling.api.resource.ValueMap" %><%

    ValueMap fieldProperties = resource.adaptTo(ValueMap.class);
    String key = resource.getName();

%>
<div class="formbuilder-content-form">
    <sling:include resource="<%=resource%>" resourceType="granite/ui/components/foundation/form/datepicker"/>
</div>
<div class="formbuilder-content-properties">

    <input type="hidden" name="./items/<%= key %>">
    <input type="hidden" name="./items/<%= key %>/jcr:primaryType" value="nt:unstructured">
    <input type="hidden" name="./items/<%= key %>/sling:resourceType" value="granite/ui/components/coral/foundation/form/datepicker">
    <input type="hidden" name="./items/<%= key %>/granite:data/metaType" value="datepicker">
    <input type="hidden" name="./items/<%= key %>/renderReadOnly" value="true">
    <input type="hidden" name="./items/<%= key %>/defaultDateField">
    <input type="hidden" name="./items/<%= key %>/value@TypeHint" value="Date">
    <input type="hidden" name="./items/<%= key %>/granite:data/typeHint" value="Date">
    <input type="hidden" name="./items/<%= key %>/type" value="datetime">
    <input type="hidden" name="./items/<%= key %>/displayedFormat" value="YYYY-MM-DD HH:mm"/>
    <%
    if (fieldProperties.containsKey("minDate")) {
    	%><input type="hidden" name="./items/<%= key %>/minDate" value="<%=fieldProperties.get("minDate", String.class) %>"/><%
    }
    if (fieldProperties.containsKey("maxDate")) {
    	%><input type="hidden" name="./items/<%= key %>/maxDate" value="<%=fieldProperties.get("maxDate", String.class) %>"/><%
    }
    %>

    <%
        String resourcePathBase = "dam/gui/coral/components/admin/schemaforms/formbuilder/formfieldproperties/";
        String[] settingsList = {"labelfields", "metadatamappertextfield", "requiredfields", "disableineditmodefields", "showemptyfieldinreadonly", "titlefields"};
        for(String settingComponent : settingsList){
            %>
                <sling:include resource="<%= resource %>" resourceType="<%= resourcePathBase + settingComponent %>"/>
            <%
        }
    %>

    <i class="delete-field coral-Icon coral-Icon--delete coral-Icon--sizeL" href="" data-target-id="<%= key %>" data-target="./items/<%= key %>@Delete"></i>

</div>


