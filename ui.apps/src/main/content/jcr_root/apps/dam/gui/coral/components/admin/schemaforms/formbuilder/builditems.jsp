<%--

  ADOBE CONFIDENTIAL
  __________________

   Copyright 2013 Adobe Systems Incorporated
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
<%@ page session="false"
         contentType="text/html"
         pageEncoding="utf-8"
         import="com.adobe.granite.ui.components.formbuilder.FormResourceManager,
                 com.day.cq.commons.LabeledResource,
                 com.adobe.granite.ui.components.Config,
                 com.day.cq.i18n.I18n,
                 java.util.HashMap,
                 org.apache.sling.api.resource.Resource,
                 org.apache.sling.api.resource.ValueMap,
                 java.util.ArrayList,
                 java.util.Iterator,
                 com.adobe.granite.confmgr.Conf,
                 com.day.cq.dam.commons.util.DamConfigurationConstants,
                 java.util.List,
                 javax.jcr.Node"
        %><%
%><%@include file="/libs/granite/ui/global.jsp" %><%
%><cq:defineObjects /><%
	Config cfg = new Config(resource);
    String sfx = slingRequest.getRequestPathInfo().getSuffix();
    sfx = sfx == null ? "" : sfx;

%>
<div class="editor-right">
    <div id="tabs-navigation-1" class="coral-TabPanel" data-init="tabs">
        <nav class="coral-TabPanel-navigation" role="tablist">
            <a id="tab-add" href="#" data-target="#field-add" data-toggle="tab" class="coral-TabPanel-tab"><%= i18n.get("Build Form") %>
            </a>
            <a id="tab-edit" href="#" data-target="#field-edit" data-toggle="tab" class="coral-TabPanel-tab"><%= i18n.get("Settings") %>
            </a>
        </nav>
		<div class="coral-TabPanel-content">
	        <section id="field-add" class="coral-TabPanel-pane is-active" role="tabpanel">
	
	            <ul id="formbuilder-field-templates" class=""><%
	                FormResourceManager formResourceManager = sling.getService(FormResourceManager.class);
	                Resource fieldTemplateResource = formResourceManager.getFormFieldResource(resource);
	            %>
	                <li class="field" data-fieldtype="section">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--viewSingle"></i><span><%= i18n.get("Section Header") %></span>
	                    </div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= fieldTemplateResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/sectionfield" />
                    </script>
	                </li>
	
	                <li class="field" data-fieldtype="text">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--text"></i><span><%= i18n.get("Single Line Text") %></span></div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= fieldTemplateResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/textfield" />
                    </script>
	                </li>
	
	                <li class="field" data-fieldtype="text">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--text"></i><span><%= i18n.get("Multi Value Text") %></span></div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= fieldTemplateResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/mvtextfield" />
                    </script>
	                </li>
	
	
	                <li class="field" data-fieldtype="number">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--dashboard"></i><span><%= i18n.get("Number","form builder option") %></span></div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= fieldTemplateResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/numberfield" />
                    </script>
	                </li>
	
	                <% Resource checkboxResource = formResourceManager.getCheckboxFieldResource(resource); %>
	                <li class="field" data-fieldtype="checkbox">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--select"></i><span><%= i18n.get("Checkbox") %></span></div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= checkboxResource %>"
                                       resourceType="dam/gui/components/admin/schemaforms/formbuilder/formfields/checkboxfield" />
                    </script>
	                </li>
	
	                <%
                        HashMap<String, Object> values = new HashMap<String, Object>();
                        values.put("sling.resolutionPath", "Field Label");
                        values.put("fieldLabel", "Default Value");
                        values.put("value", "");
                        Resource dateFieldResource = formResourceManager.getDefaultPropertyFieldResource(resource, values);
                    %>
	                <li class="field" data-fieldtype="datepicker">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--calendar"></i><span><%= i18n.get("Date") %></span></div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= dateFieldResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/datepickerfield" />
                    </script>
	                </li>
	
	                <li class="field" data-fieldtype="dropdown">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--dropdown"></i><span><%= i18n.get("Dropdown") %></span></div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= fieldTemplateResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/dropdownfield" />
                    </script>
	                    <script id="dropdown-option-template" type="text/x-handlebars-template">
                        <sling:include resource="<%= formResourceManager.getDropdownOptionResource(fieldTemplateResource) %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/dropdownfield/dropdownitem" />
                    </script>
	                </li>
	
	                <li class="field" data-fieldtype="text">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--tag"></i><span><%= i18n.get("Standard Tags") %></span></div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= fieldTemplateResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/tagsfield" />
                    </script>
	                </li>
	
	                <% Resource hiddenFieldResource = formResourceManager.getHiddenFieldResource(resource); %>
	                <li class="field" data-fieldtype="text">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--viewSingle"></i><span><%= i18n.get("Hidden Field") %></span>
	                    </div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= hiddenFieldResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/hiddenfield" />
                    </script>
	                </li>
	
	                <li class="field" data-fieldtype="reference">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--link"></i><span><%= i18n.get("Asset Referenced By") %></span></div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= fieldTemplateResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/referencefield" />
                    </script>
	                </li>
	
	                 <li class="field" data-fieldtype="reference">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--link"></i><span><%= i18n.get("Asset Referencing") %></span></div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= fieldTemplateResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/referencingfield" />
                    </script>
	                </li>
	                <li class="field" data-fieldtype="reference">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--link"></i><span><%= i18n.get("Product References") %></span></div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= fieldTemplateResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/pimfield" />
                    </script>
	                </li>
	                <li  class="field" data-fieldtype="reference">
	                	<div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--link"></i><span><%= i18n.get("Asset Rating") %></span></div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        	<sling:include resource="<%= fieldTemplateResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/assetratingfield" />
                    	</script>
	                </li>

	                <% /** we only want the youtube field for video assets */ %>
	                <% if (sfx.indexOf("video") >= 0) { %>
	                <li class="field" data-fieldtype="text">
	                    <div class="formbuilder-template-title"><i class="coral-Icon coral-Icon--sizeM coral-Icon--link"></i><span><%= i18n.get("YouTube URL List") %></span></div>
	                    <script class="field-properties" type="text/x-handlebars-template">
                        <sling:include resource="<%= fieldTemplateResource %>"
                                       resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/formfields/youtubeurllist" />
                    </script>
	                </li>
	                <% } %>
	            </ul>
	        </section>
	        <section id="formbuilder-tab-name" class="coral-TabPanel-pane tab-form-settings" role="tabpanel">
	            <div id="tab-name">
	                <sling:include resource="<%= fieldTemplateResource %>"
	                               resourceType="dam/gui/coral/components/admin/schemaforms/formbuilder/tabname" />
	            </div>
	            <div class="placeholder"><i><%= i18n.get("Select a metadata schema editor field to edit") %>
	            </i></div>
	        </section>
	    </div>
    </div>
</div>
