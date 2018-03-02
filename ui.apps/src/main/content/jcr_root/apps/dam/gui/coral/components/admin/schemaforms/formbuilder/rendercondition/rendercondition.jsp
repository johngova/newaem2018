<%--
  ADOBE CONFIDENTIAL

  Copyright 2014 Adobe Systems Incorporated
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and may be covered by U.S. and Foreign Patents,
  patents in process, and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%><%@page session="false"
			import="com.adobe.granite.ui.components.Config,
					org.apache.sling.tenant.Tenant,
					javax.jcr.Session,
					javax.jcr.security.AccessControlManager,
					com.adobe.granite.confmgr.Conf,
                    com.day.cq.dam.commons.util.DamConfigurationConstants,
				    javax.jcr.security.Privilege"
%><%@include file="/libs/granite/ui/global.jsp"
%><%
Session session = resourceResolver.adaptTo(Session.class);
AccessControlManager acm = session.getAccessControlManager();
String schemaExtHome = slingRequest.getParameter("formPath");

Privilege[] p = {acm.privilegeFromName(Privilege.JCR_ADD_CHILD_NODES),
				 acm.privilegeFromName(Privilege.JCR_MODIFY_PROPERTIES),
				 acm.privilegeFromName(Privilege.JCR_REMOVE_NODE),
				 acm.privilegeFromName(Privilege.JCR_REMOVE_CHILD_NODES)};

request.setAttribute("dam.ui.rendercondition", acm.hasPrivileges(schemaExtHome, p));

%>