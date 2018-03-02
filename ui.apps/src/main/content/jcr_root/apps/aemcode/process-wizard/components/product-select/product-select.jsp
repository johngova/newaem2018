<%@include file="/libs/foundation/global.jsp"%>
<%@page session="false"
          import="java.util.Iterator,
                  java.util.List,
                  org.apache.sling.api.resource.Resource,
                  org.apache.sling.api.resource.ValueMap,
                  com.adobe.granite.ui.components.Config,
                  com.adobe.granite.ui.components.ComponentHelper,
                  com.adobe.granite.ui.components.ds.DataSource,
                  org.apache.commons.lang.StringUtils"  %>


<%
    final ComponentHelper cmp = new ComponentHelper(pageContext);
       DataSource ds = cmp.getItemDataSource();
       if(null != ds) {
            Iterator<Resource> dsIte = ds.iterator();
            while(dsIte.hasNext()){
                Resource res = (Resource) dsIte.next();
                ValueMap map = res.getValueMap();
                Iterator iter = map.keySet().iterator();
                while(iter.hasNext()) {
                    String key = (String) iter.next();
                    if(key.equals("productData")) {
                        String product_Data = (String) map.get("productData");
                        if(StringUtils.isNotBlank(product_Data))
                            out.println(product_Data);
                    }
                }
            }
     }
%>
