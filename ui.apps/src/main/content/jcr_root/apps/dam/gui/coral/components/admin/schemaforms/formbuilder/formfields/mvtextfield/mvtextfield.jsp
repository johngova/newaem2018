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
         import="org.apache.sling.api.resource.ValueMap" %><%

	ValueMap fieldProperties = resource.adaptTo(ValueMap.class);
	String key = resource.getName();
    String resourcePathBase = "dam/gui/coral/components/admin/schemaforms/formbuilder/formfieldproperties/";
%>

<div class="formbuilder-content-form">
    <label class="fieldtype"><i class="coral-Icon coral-Icon--sizeXS coral-Icon--text"></i><%= i18n.get("Multi Value Text Field") %></label>
    <sling:include resource="<%= resource %>" resourceType="dam/gui/components/admin/formelements/mvtextfield"/>
</div>
<div class="formbuilder-content-properties">

    <input type="hidden" name="./items/<%= key %>">
    <input type="hidden" name="./items/<%= key %>/jcr:primaryType" value="nt:unstructured">
    <input type="hidden" name="./items/<%= key %>/sling:resourceType" value="granite/ui/components/coral/foundation/form/multifield">
    <input type="hidden" name="./items/<%= key %>/granite:data/metaType" value="mvtext">
    <input type="hidden" name="./items/<%= key %>/renderReadOnly" value="true">
    <input type="hidden" name="./items/<%= key %>/field">
    <input type="hidden" name="./items/<%= key %>/field/jcr:primaryType" value="nt:unstructured">
    <input type="hidden" name="./items/<%= key %>/field/sling:resourceType" value="granite/ui/components/coral/foundation/form/textfield">



    <sling:include resource="<%= resource %>" resourceType="<%= resourcePathBase + "labelfields"%>"/>
    <%request.setAttribute("cq.dam.metadataschema.builder.field.relativeresource", "field"); %>
    <sling:include resource="<%= resource %>" resourceType="<%= resourcePathBase + "metadatamappertextfield"%>"/>
    <%request.removeAttribute("cq.dam.metadataschema.builder.field.relativeresource"); %>
    <sling:include resource="<%= resource %>" resourceType="<%= resourcePathBase + "placeholderfields"%>"/>
    <%request.setAttribute("cq.dam.metadataschema.builder.field.relativeresource", "field"); %>
    <sling:include resource="<%= resource %>" resourceType="<%= resourcePathBase + "requiredfields"%>"/>
    <%request.removeAttribute("cq.dam.metadataschema.builder.field.relativeresource"); %>
    <sling:include resource="<%= resource %>" resourceType="<%= resourcePathBase + "showemptyfieldinreadonly" %>"/>

    <sling:include resource="<%= resource %>" resourceType="<%= resourcePathBase + "titlefields" %>" />

    <i class="delete-field coral-Icon coral-Icon--delete coral-Icon--sizeL" href="" data-target-id="<%= key %>" data-target="./items/<%= key %>@Delete"></i>


</div>
