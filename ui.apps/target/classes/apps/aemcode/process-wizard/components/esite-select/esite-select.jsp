<%@include file="/libs/foundation/global.jsp"%>
<%@page session="false"
          import="java.util.Iterator,
                  java.util.List,
                  org.apache.sling.api.resource.Resource,
                  org.apache.sling.api.resource.ValueMap,
                  com.adobe.granite.ui.components.ds.DataSource,
				  org.apache.sling.commons.json.JSONObject,
				  org.apache.sling.commons.json.JSONException,
                  com.adobe.granite.ui.components.ComponentHelper,
                  com.adobe.granite.ui.components.Config,
                  org.slf4j.Logger,
                  org.slf4j.LoggerFactory"  %>

<%
final ComponentHelper cmp = new ComponentHelper(pageContext);
DataSource ds = cmp.getItemDataSource();
List<String> esitesData = null;
if(null != ds) {
  if(null != slingRequest.getAttribute("esiteLocales")) {
        esitesData = (List<String>) slingRequest.getAttribute("esiteLocales");
   }
Iterator<Resource> dsIte = ds.iterator();
while(dsIte.hasNext()){
Resource res = (Resource) dsIte.next();
    ValueMap map = res.getValueMap();
    Iterator iter = map.keySet().iterator();
    out.println("<section class='coral-Form-fieldset'>");
    out.println("<h3 class='coral-Form-fieldset-legend'>eSites Selection</h3>");
    out.println("<ul class='foundation-nestedcheckboxlist' data-foundation-nestedcheckboxlist-disconnected='false'>");
    while(iter.hasNext()){
		String key = (String) iter.next();
        if(key.equals("root")) {
			JSONObject esiteObj = (JSONObject) map.get("root");
            JSONObject esiteRoot = esiteObj.getJSONObject("kdaroot");    
            out.println(getSiteHeirarchy(esiteRoot, esitesData));
        }
    }
    out.println("</ul>");
    out.println("</section>");
  }
}
%>


<%! 
    final int nextLevel = 3; 
    final Logger log = LoggerFactory.getLogger(getClass());
    
    //Actual Checkboxes are appended in this method
    private String createLocaleOptions(JSONObject localeObj, List<String> esitesData) throws JSONException{
              StringBuffer buf = new StringBuffer();
              String isChecked = "";
              if(null != esitesData && esitesData.contains(localeObj.getString("path"))) {
                isChecked = "checked";
              }
    	      buf.append("<li class='foundation-nestedcheckboxlist-item'>");
              buf.append("<div class='coral-Form-fieldwrapper coral-Form-fieldwrapper--singleline'><label class='coral-Checkbox coral-Form-field'>");
              buf.append("<input name='esite:" + localeObj.getString("name") + "' value='" + localeObj.getString("path") + "' data-validation='' class='coral-Checkbox-input' type='checkbox' " + isChecked + ">");
              buf.append("<span class='coral-Checkbox-checkmark'></span>");
              buf.append("<span class='coral-Checkbox-description'>" + localeObj.getString("title") + "</span>");
              buf.append("</label></div>");
    
			  if(localeObj.has("childs")){
                buf.append("<ul class='foundation-nestedcheckboxlist' data-foundation-nestedcheckboxlist-disconnected='false'>");
			    JSONObject childObj = localeObj.getJSONObject("childs");
                Iterator<String> keys = childObj.keys();
                while(keys.hasNext()) {
                   String key = keys.next();
                   buf.append(createLocaleOptions(childObj.getJSONObject(key), esitesData));
                }
                buf.append("</ul>");
              }
    
              buf.append("</li>"); 
    	      return buf.toString(); 
	}

    // Returns the prepared UI html element for all the locales to the SiteHeirarchy
	private String getLocalesUI(JSONObject rootChild, List<String> esitesData) throws JSONException {
        StringBuffer buf = new StringBuffer();
        Iterator<String> keys = rootChild.keys();
        while(keys.hasNext()){
            String locale = keys.next();
            JSONObject languageNode = rootChild.getJSONObject(locale);
            buf.append(createLocaleOptions(languageNode, esitesData));
        	buf.append("<br/>");
         }
		return buf.toString();
    }
    

    // get's the site heirarchy based on the JSONObject provided
    private String getSiteHeirarchy(JSONObject esiteRoot, List<String> esitesData) throws JSONException {
    String finalJSON = "";
          if(esiteRoot.has("title")) {
              finalJSON = getLocalesUI(esiteRoot, esitesData);            
          } else {
             if(esiteRoot.has("childs"))
             	finalJSON = getLocalesUI(esiteRoot.getJSONObject("childs"), esitesData);
          }
         return finalJSON;
    }
    
    
   
%>