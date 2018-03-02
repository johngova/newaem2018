<%@include file="/libs/granite/ui/global.jsp" %>
<%@page session="false"
        import="com.adobe.granite.ui.components.Config,com.adobe.granite.ui.components.ExpressionHelper,com.day.cq.commons.inherit.HierarchyNodeInheritanceValueMap,com.day.cq.commons.inherit.InheritanceValueMap,org.apache.commons.lang.StringUtils,java.util.Map,java.util.HashMap, java.util.Iterator,
                  java.util.regex.Matcher,
                  java.util.regex.Pattern" %>
<%

    Config cfg = cmp.getConfig();
    
    String[] currentAssetPath = slingRequest.getParameterValues("item");
   
    Resource currentAssetResource = resourceResolver.getResource(currentAssetPath[0] + "/jcr:content");

    InheritanceValueMap inheritedProps = new HierarchyNodeInheritanceValueMap(currentAssetResource);

    String metadataSchema = inheritedProps.getInherited("metadataSchema", String.class);

    if (StringUtils.isNotBlank(metadataSchema)) {
        metadataSchema = metadataSchema + "/items/tabs";
        // Get the resource using resourceResolver so that the search path is applied.
        Resource targetResource = resourceResolver.getResource(metadataSchema);
        if (targetResource == null) {
            return;
        }
          
        createUpdatePropertiesWidget(targetResource.listChildren());     
        out.println(generateCoralDropdownField(propMap, isUploadsFolder(currentAssetPath[0])));
        
    }
%>
<%
    for(String assetPath : currentAssetPath) { %>
		<input type="hidden" name="assetPath" value="<%=assetPath%>"/>
<%}%>
    
<%!
        
   private final String uploadsFolderPattern = "/content/dam/kdc/kdag(/.*/)uploads";
   private final Pattern uploadPattern = Pattern.compile(uploadsFolderPattern);
   private final String processedFolderPattern = "/content/dam/kdc/kdag(/.*/)processed";
   private final Pattern processedPattern = Pattern.compile(processedFolderPattern);
   Map<String, String> propMap = new HashMap<String, String>();
   private void createUpdatePropertiesWidget(Iterator iterator) {

            while(iterator.hasNext()) {
                Resource nextResource = (Resource) iterator.next();
                ValueMap vm = nextResource.getValueMap();
                if(vm.containsKey("name")) {
                    propMap.put(vm.get("fieldLabel", String.class), vm.get("name", String.class));
                } else {
                    createUpdatePropertiesWidget(nextResource.listChildren());
                }
            }
    }
    
    private String generateCoralDropdownField(Map<String, String> propMap, boolean isDisabled) {
    
        StringBuffer buf = new StringBuffer();
        Iterator<String> keys = propMap.keySet().iterator();
    
       
        buf.append("<section class='coral-Form-fieldset'>");
		buf.append("<div class='coral-Form-fieldwrapper'>");
    buf.append("<h2><label id='label-vertical-0' class='coral-Form-fieldlabel'>Select Properties to Update</label></h2>");
		buf.append("<coral-select class='coral-Form-field' placeholder='Select one' name='updateMetadataProperties' labelledby='label-vertical-0' multiple " + (isDisabled ? "disabled" : "") + ">");
        while(keys.hasNext()) {
            String key = keys.next();
            buf.append("<coral-select-item value='" + propMap.get(key) + "'>" + key + "</coral-select-item>");
        }
		buf.append("</coral-select>");				
		buf.append("</section>");
		buf.append("</div>");
		
        return buf.toString();
    }
    
    public boolean isUploadsFolder(String assetPath) {
		  Matcher uploadMatch = uploadPattern.matcher(assetPath);
		  Matcher processedMatch = processedPattern.matcher(assetPath);
		  return (uploadMatch.find() && !processedMatch.find());
	   }
    
%>