
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
                 com.adobe.granite.ui.components.Config,
         		 java.util.HashMap" %><%
    Config cfg = new Config(resource);
    ValueMap fieldProperties = resource.adaptTo(ValueMap.class);
    String key = resource.getName();

%>

<div class="formbuilder-content-form">
    <sling:include resource="<%= resource %>" resourceType="granite/ui/components/foundation/form/checkbox"/>
</div>
<div class="formbuilder-content-properties">

    <input type="hidden" name="./items/<%= key %>">
    <input type="hidden" name="./items/<%= key %>/jcr:primaryType" value="nt:unstructured">
    <input type="hidden" name="./items/<%= key %>/sling:resourceType" value="granite/ui/components/coral/foundation/form/checkbox">
    <input type="hidden" name="./items/<%= key %>/renderReadOnly" value="true">
    <input type="hidden" name="./items/<%= key %>/granite:data/metaType" value="checkbox">
    <input type="hidden" name="./items/<%= key %>/value" value="true">

    <%--<sling:include resource="<%= resource %>" resourceType="/libs/dam/gui/components/admin/schemaforms/formbuilder/formfieldproperties/systemfields"/>--%>

    <sling:include resource="<%= resource %>" resourceType="dam/gui/components/admin/schemaforms/formbuilder/formfieldproperties/textfields"/>

    <sling:include resource="<%= resource %>" resourceType="dam/gui/components/admin/schemaforms/formbuilder/formfieldproperties/metadatamappertextfield"/>

    <%--<sling:include resource="<%= resource %>" resourceType="/libs/dam/gui/components/admin/schemaforms/formbuilder/formfieldproperties/hiddenfields/valuefield"/>--%>

    <%--sling:include resource="<%= resource %>" resourceType="/libs/dam/gui/components/admin/schemaforms/formbuilder/formfieldproperties/requiredfields"/--%>

    <sling:include resource="<%= resource %>" resourceType="dam/gui/components/admin/schemaforms/formbuilder/formfieldproperties/disableineditmodefields"/>
    
    <sling:include resource="<%= resource %>" resourceType="dam/gui/components/admin/schemaforms/formbuilder/formfieldproperties/showemptyfieldinreadonly"/>


    <% Boolean defaultchecked = fieldProperties.get("defaultchecked", Boolean.class); %>
    <div class="coral-Form-fieldwrapper coral-Form-fieldwrapper--singleline">
        <label class="coral-Label">
            <input type="checkbox" class="coral-Checkbox-input" name="./items/<%= key %>/defaultchecked" value="true" 
                                                     <%= defaultchecked == null || !defaultchecked ? "" : "checked=\"checked\""%>>
            <span class="coral-Checkbox-checkmark"></span>
            <span class="coral-Checkbox-description"><%= i18n.get("Default") %></span>
        </label>
    </div>
    
    <input type="hidden" name="./items/<%= key %>/value@Delete" value="true">
    <input type="hidden" name="./items/<%= key %>/value@TypeHint" value="Boolean">

    <sling:include resource="<%= resource %>" resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfieldproperties/titlefields"/>

    <i class="delete-field coral-Icon coral-Icon--delete coral-Icon--sizeL" href="" data-target-id="<%= key %>" data-target="./items/<%= key %>@Delete"></i>

</div>
