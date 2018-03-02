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
         import="com.adobe.granite.ui.components.Config,
                  com.adobe.granite.ui.components.ds.ValueMapResource,
                  org.apache.sling.api.resource.ValueMap,
                  org.apache.sling.api.wrappers.ValueMapDecorator,
                  java.util.HashMap" %><%

    Config cfg = new Config(resource);
	String key = resource.getName();
    ValueMap tagsPickerProperties = new ValueMapDecorator(new HashMap<String, Object>());
    tagsPickerProperties.put("fieldLabel", cfg.get("fieldLabel","Tags"));
    ValueMapResource valueMapResource = new ValueMapResource(resourceResolver, resource.getPath(), "granite/ui/components/foundation/form/textfield", tagsPickerProperties);
%>

<div class="formbuilder-content-form">
    <label class="fieldtype"><i class="coral-Icon coral-Icon--sizeXS coral-Icon--tag"></i><%= i18n.get("Tags") %></label>
    <sling:include resource="<%= valueMapResource %>"/>
</div>
<div class="formbuilder-content-properties">

    <input type="hidden" name="./items/<%= key %>">
    <input type="hidden" name="./items/<%= key %>/jcr:primaryType" value="nt:unstructured">
    <input type="hidden" name="./items/<%= key %>/cq-msm-lockable" value="cq:tags">
    <input type="hidden" name="./items/<%= key %>/sling:resourceType" value="cq/gui/components/common/tagspicker">
    <input type="hidden" name="./items/<%= key %>/metaType" value="tags">
    <input type="hidden" name="./items/<%= key %>/renderReadOnly" value="true">
    <input type="hidden" name="./items/<%= key %>/renderReadOnly@TypeHint" value="Boolean"/>
    <input type="hidden" name="./items/<%= key %>/allowCreate" value="true"/>
    <input type="hidden" name="./items/<%= key %>/allowCreate@TypeHint" value="Boolean"/>
    <input type="hidden" name="./items/<%= key %>/cq:showOnCreate" value="true"/>
    <input type="hidden" name="./items/<%= key %>/cq:showOnCreate@TypeHint" value="Boolean"/>

    <%
        String resourcePathBase = "dam/gui/coral/components/admin/schemaforms/formbuilder/formfieldproperties/";
        String[] settingsList = {"labelfields", "metadatamappertextfield", "disableineditmodefields", "showemptyfieldinreadonly", "titlefields"};
        for(String settingComponent : settingsList){
            %>
            <sling:include resource="<%= resource %>" resourceType="<%= resourcePathBase + settingComponent %>"/>
            <%
        }
    %>

    <i class="delete-field coral-Icon coral-Icon--delete coral-Icon--sizeL" href="" data-target-id="<%= key %>" data-target="./items/<%= key %>@Delete"></i>

</div>
