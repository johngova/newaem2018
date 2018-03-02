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
         		 org.apache.sling.api.resource.ValueMap" %><% 

    ValueMap itemProperties = resource.adaptTo(ValueMap.class);
    String key = resource.getName();

    String parentKey;
    if (resource.getParent() == null){
        FormResourceManager formResourceManager = sling.getService(FormResourceManager.class);
        parentKey = formResourceManager.getFieldTemplateID();
    } else {
        parentKey = resource.getParent().getParent().getName();
    }
    String identifier = "list-" + parentKey + "-option-" + key;
%>
<tr id="<%= identifier %>" class="dropdown-option" >
    <td> <input type="radio"  name="<%= parentKey %>-DefaultValue" value="1"><span></span></td>
    <td>
        <input type="hidden"  name="./items/<%= parentKey %>/items/<%= key %>">
        <input type="hidden"  name="./items/<%= parentKey %>/items/<%= key %>/jcr:primaryType" value="nt:unstructured">
        <%
        if (itemProperties.containsKey("selected")) {
            %>
            <input type="hidden"  name="./items/<%= parentKey %>/items/<%= key %>/selected" value="<%= itemProperties.get("selected", Boolean.class) %>">
        	<input type="hidden"  name="./items/<%= parentKey %>/items/<%= key %>/selected@TypeHint" value="Boolean">
            <%
        }
        %>
        <% if (key.equals("none")) {%>
        <input class="dropdown-option-text coral-Textfield" type="text" placeholder="<%= i18n.get("Option text") %>" name="./items/<%= parentKey %>/items/<%= key %>/text"
               value="">
        <%} else {%>
        <input class="dropdown-option-text coral-Textfield" type="text" placeholder="<%= i18n.get("Option text") %>" name="./items/<%= parentKey %>/items/<%= key %>/text"
               value="<%= xssAPI.encodeForHTMLAttr(itemProperties.get("text", "")) %>">
        <%}%>
        <input class="dropdown-option-value coral-Textfield" type="text" placeholder="<%= i18n.get("Option value") %>" name="./items/<%= parentKey %>/items/<%= key %>/value"
               value="<%= xssAPI.encodeForHTMLAttr(itemProperties.get("value", "")) %>">
    </td>
    <td>
        <a class="remove-dropdown-option"
           data-name="./items/<%= parentKey %>/items/<%= key %>/@Delete"
           data-target="#<%= identifier %>"
           data-target-parent="#list-<%= parentKey %>">
           <i class="coral-Icon coral-Icon--minus coral-MinimalButton-icon"></i>
        </a>
    </td>
</tr>
