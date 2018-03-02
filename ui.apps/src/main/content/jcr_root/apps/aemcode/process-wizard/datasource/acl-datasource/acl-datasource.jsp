<%@include file="/libs/granite/ui/global.jsp"%><%@page session="false"
	import="java.util.Map,
                  java.util.HashMap,
                  java.util.Iterator,
                  java.util.List,
                  org.apache.commons.lang.StringUtils,
                  org.apache.commons.collections.Transformer,
                  org.apache.commons.collections.iterators.TransformIterator,
                  org.apache.sling.api.resource.Resource,
                  org.apache.sling.api.resource.ResourceMetadata,
                  org.apache.sling.api.resource.ResourceResolver,
                  org.apache.sling.api.resource.ValueMap,
                  org.apache.sling.api.wrappers.ValueMapDecorator,
                  com.adobe.granite.ui.components.ds.DataSource,        
                  com.adobe.granite.ui.components.ds.SimpleDataSource,
                  com.adobe.granite.ui.components.ds.ValueMapResource,
				  org.apache.sling.commons.json.JSONObject,
                  com.adobe.granite.ui.components.Config,
				  org.apache.sling.commons.json.JSONException,
                  org.slf4j.Logger,
                  org.slf4j.LoggerFactory,
                  org.apache.sling.api.SlingHttpServletRequest,
                  java.util.regex.Matcher,
                  java.util.regex.Pattern"%>

    <%   
       List<String> aclProperty = null;
       if(null != slingRequest.getAttribute("accesscontrol")) {
            aclProperty = (List<String>) slingRequest.getAttribute("accesscontrol");
       }
       isProcessedAsset = checkIfisProcessed(slingRequest);
       isDisabled = (slingRequest.getParameterValues("item").length > 1) ? false : isUploadsFolder(slingRequest.getParameter("item"));
       final ResourceResolver resolver = resourceResolver;
       Config cfg = cmp.getConfig();
       String[] acl_list_pages = cfg.get("aclLibraryPath", String[].class);
       StringBuffer buf = new StringBuffer();
       for(int i = 0; (null != acl_list_pages) && i < acl_list_pages.length; i++) {
            String aclPage = acl_list_pages[i];
            buf.append(populateUI(aclPage, resourceResolver, aclProperty, slingRequest));
       }
        final Map<String, String> aclData = new HashMap<String, String>();
        if(StringUtils.isNotBlank(buf.toString()))
            aclData.put("aclData", buf.toString());
	    @SuppressWarnings("unchecked")
		DataSource ds = new SimpleDataSource(
				new TransformIterator(aclData.keySet().iterator(), new Transformer() {
					public Object transform(Object input) {
						try {
							String lang = (String) input;
							ValueMap vm = new ValueMapDecorator(new HashMap<String, Object>());
							vm.put(lang, aclData.get(lang));
							return new ValueMapResource(resolver, new ResourceMetadata(), "nt:unstructured",
									vm);
						} catch (Exception e) {
							throw new RuntimeException(e);
						}
					}
				}));
		request.setAttribute(DataSource.class.getName(), ds);
%>
    
    
 <%!
        private final String uploadsFolderPattern = "/content/dam/kdc/kdag(/.*/)uploads";
	    private final Pattern uploadPattern = Pattern.compile(uploadsFolderPattern);
	    private final String processedFolderPattern = "/content/dam/kdc/kdag(/.*/)processed";
	    private final Pattern processedPattern = Pattern.compile(processedFolderPattern);
        Logger log = LoggerFactory.getLogger(getClass()); 
        boolean isDisabled = false;
        boolean isProcessedAsset = false;
        
     
        private String populateUI(String acl_Page, ResourceResolver resolver, List<String> aclProperty, SlingHttpServletRequest request) {
            String updateCheckBoxStatus = isDisabled ? "disabled" : "";
            String availableInPublicSiteStatus = StringUtils.EMPTY;
            if(null != request.getAttribute("includeInPublicSite")) {
                availableInPublicSiteStatus = "checked";
            }
            StringBuffer aclUI = new StringBuffer();            
            aclUI.append("<h3>Available in Public Site?</h3>");
            aclUI.append("<coral-checkbox value='true' name='updateAvailableInPublicSite' " + updateCheckBoxStatus + ">");
            aclUI.append("Update - Available in Public Site");
            aclUI.append("</coral-checkbox>"); 
            aclUI.append("</br>");
            
            aclUI.append("<coral-checkbox value='true' name='availableInPublicSite' " + availableInPublicSiteStatus + ">");
            aclUI.append("Available in Public Site");
            aclUI.append("</coral-checkbox>"); 
            aclUI.append("</br></br>");
     
            Resource resource = resolver.resolve(acl_Page);
            if(null != resource && null != resource.getChild("jcr:content/member-attr-par")) {
                Resource parResource = resource.getChild("jcr:content/member-attr-par");
                if(null != parResource) {
                    Iterator<Resource> attributesIterator = parResource.listChildren();
                    while (attributesIterator.hasNext()) {
                        Resource attributeResource = attributesIterator.next();
                        String groupName = attributeResource.getValueMap().get("groupName").toString();
                        if(StringUtils.isNotBlank(groupName)) {
                            aclUI.append("<strong><font size='4'>" + groupName + "</font></strong>");
                            aclUI.append("<br/>");
                            aclUI.append("&nbsp; &nbsp;");
                            aclUI.append("<coral-checkbox value='true' name='update" + StringUtils.deleteWhitespace(groupName) + "' " + updateCheckBoxStatus + ">");
                            aclUI.append("Update - ");
                    		aclUI.append(groupName);
                    		aclUI.append("</coral-checkbox>"); 
                    		aclUI.append("</br>");
                        } 
                        aclUI.append("<section class='coral-Form-fieldset'>");
                        if(null != attributeResource.getChild("memberAttributes")) {
                            Iterator<Resource> childAttributesIterator = attributeResource.getChild("memberAttributes").listChildren();
                            while(childAttributesIterator.hasNext()) {
                                Resource itemResource = childAttributesIterator.next();
                                aclUI.append(populateAttributeUI(itemResource, groupName, aclProperty));
                            }
                        }
                        aclUI.append("</section>");
                    }
                }  
            }
            return aclUI.toString();
        }
    
        private String populateAttributeUI(Resource resource, String groupName, List<String> aclProperty) {
            ValueMap valueMap = resource.getValueMap();
            String isEmployee = (groupName.equals("Partner Type") && valueMap.get("label").equals("Employee") && (!isProcessedAsset || (isProcessedAsset && (null != aclProperty && aclProperty.contains(valueMap.get("value")))))) ? "checked" : "";
            String isChecked = "";
            if(null != aclProperty && StringUtils.isBlank(isEmployee) && (null != aclProperty && aclProperty.contains(valueMap.get("value")))) {
                isChecked = "checked";
            }
            StringBuffer buf = new StringBuffer();
            buf.append("<coral-checkbox value='" + groupName + "/" + valueMap.get("value") + "' name='aclWidget:" + valueMap.get("label") + "'" + isEmployee + isChecked + ">");
		    buf.append(valueMap.get("label"));
            buf.append("</coral-checkbox>"); 
            buf.append("</br>");
            return buf.toString();
        }
    
        public boolean isUploadsFolder(String assetPath) {
		  Matcher uploadMatch = uploadPattern.matcher(assetPath);
		  Matcher processedMatch = processedPattern.matcher(assetPath);
		  return (uploadMatch.find() && !processedMatch.find());
	   }
    
        private boolean checkIfisProcessed(SlingHttpServletRequest request) {
            if(null != request.getParameterValues("item") && !(request.getParameterValues("item").length > 1)) {
                Resource resource = request.getResourceResolver().resolve(request.getParameter("item"));
                if(null != resource) {
                    Resource metadataResource = resource.getChild("jcr:content/metadata");
                    ValueMap map = metadataResource.getValueMap();
                    if(map.containsKey("kdc:isProcessedAsset")) {
                        return true;
                    }
                }
            }
            return false;
        }
    %>