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
                   com.adobe.granite.ui.components.ds.ValueMapResource,
                   org.apache.sling.api.resource.Resource,
                   org.apache.sling.api.wrappers.ValueMapDecorator,
                   org.apache.commons.io.IOUtils,
                   org.apache.sling.api.resource.ResourceMetadata,
                   org.apache.sling.commons.json.JSONArray,
                   org.apache.sling.commons.json.JSONObject,
                   java.util.HashMap,  
                   java.io.InputStream,
                   java.util.Map,				  
                   java.util.Iterator" %><%

    String key = resource.getName();
%>
<div class="formbuilder-content-form">
    <sling:include resource="<%=resource%>" resourceType="granite/ui/components/foundation/form/select"/>
</div>

<div class="formbuilder-content-properties">

    <input type="hidden" name="./items/<%= key %>">
    <input type="hidden" name="./items/<%= key %>/jcr:primaryType" value="nt:unstructured">
    <input type="hidden" name="./items/<%= key %>/sling:resourceType" value="granite/ui/components/coral/foundation/form/select">
    <input type="hidden" name="./items/<%= key %>/granite:data/metaType" value="dropdown">
    <input type="hidden" name="./items/<%= key %>/renderReadOnly" value="true">
    <input type="hidden" name="./items/<%= key %>/items">
    <input type="hidden" name="./items/<%= key %>/items/jcr:primaryType" value="nt:unstructured">
    <input type="hidden" name="./items/<%= key %>/value" value="">

    <%
        String resourcePathBase = "dam/gui/coral/components/admin/schemaforms/formbuilder/formfieldproperties/";
        String[] settingsList = {"labelfields", "jsonfields", "metadatamappertextfield", "disableineditmodefields", "multivalue", "showemptyfieldinreadonly", "orderedlist"};
        for(String settingComponent : settingsList){
            %>
                <sling:include resource="<%= resource %>" resourceType="<%= resourcePathBase + settingComponent %>"/>
            <%
        }
    %>
    
    <label for="">
        <span><%= xssAPI.encodeForHTML(i18n.get("Choices")) %></span>

        <table id="list-<%= key %>" class="dropdown-options" data-list-id="<%= key %>">
            <tbody >

            <tr class="dropdown-option" >
                <td> <input type="radio" class="" disabled="true" ><span></span> </td>
                <td> <input id="template-option-<%= key %>" class="dropdown-option-template coral-Textfield" type="text" value="" disabled placeholder="<%=i18n.get("Type Category Name")%>"> </td>
                <td>
                	<a class="append-dropdown-option" data-value="template-option-<%= key %>" data-target="list-<%= key %>" data-target-parent="<%= key %>">
                		<i class="coral-Icon coral-Icon--add coral-MinimalButton-icon"></i>
	                </a>
                </td>
            </tr>
				<%
                ValueMap properties = resource.adaptTo(ValueMap.class);
                String jsonPath = properties.get("jsonPath", String.class);
                Resource jsonResource = resourceResolver.getResource(jsonPath);
                if (jsonResource != null) {

                    InputStream is = jsonResource.adaptTo(InputStream.class);
                    String jsonText = IOUtils.toString(is, "UTF-8");
                    JSONObject obj = new JSONObject(jsonText);
                    JSONArray options = obj.getJSONArray("options");
                    HashMap map = new HashMap();
                    map.put("text", "none");
                    map.put("value", "");
                    ValueMapResource syntheticResource = new ValueMapResource(resourceResolver, resource.getPath()+"/items/"+"none", "", new ValueMapDecorator(map));
                    %><sling:include resource="<%= syntheticResource %>" resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/dropdownfield/dropdownitem" /><%
                    for (int i = 0 ; i <options.length(); i++) {
                        obj = options.getJSONObject(i);
                        map.put("text", obj.get("text"));
                        map.put("value", obj.get("value"));
                        syntheticResource = new ValueMapResource(resourceResolver, resource.getPath()+"/items/"+obj.get("text"), "", new ValueMapDecorator(map));
                        %><sling:include resource="<%= syntheticResource %>" resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/dropdownfield/dropdownitem" />
				<%
                    }
                } else
                if (resource.getChild("items") != null) {
                    Iterator<Resource> formfields = resource.getChild("items").listChildren();
                    while (formfields.hasNext()) {
                        Resource itemResource = formfields.next();
                        %><sling:include resource="<%= itemResource %>" resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/dropdownfield/dropdownitem"/><%
                    }
                }
            %>

            </tbody>
        </table>
    </label>

    <sling:include resource="<%= resource %>" resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfieldproperties/titlefields"/>

    <i class="delete-field coral-Icon coral-Icon--delete coral-Icon--sizeL" href="" data-target-id="<%= key %>" data-target="./items/<%= key %>@Delete"></i>

</div>
