<%@include file="/libs/foundation/global.jsp"%><%@page session="false"
	import="java.util.Map,
                  java.util.HashMap,
                  java.util.Iterator,
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
				  org.apache.sling.commons.json.JSONException,
                  java.util.regex.Matcher,
                  java.util.regex.Pattern,
                  org.slf4j.Logger,
                  org.slf4j.LoggerFactory,
                  org.apache.sling.api.SlingHttpServletRequest"%>
    
<%
	final ResourceResolver resolver = resourceResolver;
	String itemPath = slingRequest.getParameter("item");
	if (null != itemPath) {
		Resource pageResource = resolver.resolve(itemPath);
		final Map<String, Object> esiteHirarchy = getEsiteHirarchy(itemPath, damPath, slingRequest);
		
	    @SuppressWarnings("unchecked")
		DataSource ds = new SimpleDataSource(
				new TransformIterator(esiteHirarchy.keySet().iterator(), new Transformer() {
					public Object transform(Object input) {
						try {
							String lang = (String) input;
							ValueMap vm = new ValueMapDecorator(new HashMap<String, Object>());
							vm.put(lang, esiteHirarchy.get(lang));
							return new ValueMapResource(resolver, new ResourceMetadata(), "nt:unstructured",
									vm);
						} catch (Exception e) {
							throw new RuntimeException(e);
						}
					}
				}));
		request.setAttribute(DataSource.class.getName(), ds);
     }
%>

<%!
    
	final String damPath = "/content/dam/kdc/kdag";
    final String uploadsFolderPattern = "/content/dam/kdc/kdag(/.*/)uploads";
    final Pattern uploadPattern = Pattern.compile(uploadsFolderPattern);
    final String processedFolderPattern = "/content/dam/kdc/kdag(/.*/)processed";
    final Pattern processedPattern = Pattern.compile(processedFolderPattern);
    
    final int folderLevels = 3;
    final Logger log = LoggerFactory.getLogger(getClass());
    
    
    // To get the site heirarchy Map
	private Map<String, Object> getEsiteHirarchy(String itemPath, String damPath, SlingHttpServletRequest request) {
		Map<String, Object> esiteMap = new HashMap<String, Object>();
        ResourceResolver resolver = request.getResourceResolver();
		try {
			Resource kdaRoot = getLocaleResource(itemPath, damPath, resolver);
			if (null != kdaRoot) {
				esiteMap.put("root", getEsite(kdaRoot, resolver.resolve(itemPath), request));
			}
		} catch (JSONException e) {
            log.error("Exception in Process Wizard: " + e);
			throw new RuntimeException(e);
		}
		return esiteMap;
	}
    
    // to get the locale folder and its contents - for both in processed/uploads or in regular folder
	private Resource getLocaleResource(String itemPath, String damPath, ResourceResolver resolver) {
		Resource damResource = null;
        if (isUploadFolder(itemPath)) {
            if(itemPath.lastIndexOf("/uploads/") != -1)
                itemPath = itemPath.substring(0, itemPath.lastIndexOf("/uploads/"));
            else
                itemPath = itemPath.substring(0, itemPath.lastIndexOf("/processed/"));
			damResource = resolver.resolve(itemPath);
		} else {
			if (itemPath.startsWith(damPath)) {
				damResource = getParentResource(resolver.resolve(itemPath).getParent().getPath(), itemPath, resolver);
			}
		}
		return damResource;
	}
    

    //returns the JSONObject with the site structure based on the folder uploaded
	private JSONObject getEsite(Resource resource, Resource itemResource, SlingHttpServletRequest request) throws JSONException {

        JSONObject esiteObj = new JSONObject();
        if(null != itemResource) {
            boolean isFullSite = false;
            if(isUploadFolder(itemResource.getPath()))
                isFullSite = true;            
            if(!isFullSite && !resource.getPath().equals(itemResource.getPath())) {
                 String suffix = request.getRequestPathInfo().getSuffix();
                 Resource actualResource = getActualSiteResource(resource, request.getResourceResolver().resolve(suffix));
                 JSONObject actualResourceDetailsObject = getResourceDetails(actualResource).put("childs", getChildResourceObject(actualResource, itemResource, folderLevels - 2));
                 JSONObject childsObj = new JSONObject().put("childs", new JSONObject().put(resource.getName(), getResourceDetails(resource).put("childs", new JSONObject().put(actualResource.getName(), actualResourceDetailsObject))));
                 esiteObj.put("kdaroot", childsObj);
            } else {
                 esiteObj.put("kdaroot", new JSONObject().put("childs", getChildResourceObject(resource, itemResource, folderLevels)));
            }
        }
        return esiteObj;
	}
    
    //gets the next level of parent
    private Resource getActualSiteResource(Resource parent, Resource child) {
        if(child.getPath().equals("/content")) {
            return null;
        } else if(child.getParent().getPath().equals(parent.getPath())) {
            return child;
        } else {
            return getActualSiteResource(parent, child.getParent());
        }
    }
    
    
    //gets the child resources recursively based on the given resource
	private JSONObject getChildResourceObject(Resource childResource, Resource itemResource, int folderLevels) throws JSONException {
        JSONObject langObject = new JSONObject();        
            int nextLevel = folderLevels - 1;
		    Iterator<Resource> childResources = childResource.listChildren();
            if(null != childResource) {
			     while (childResources.hasNext()) {
				    Resource localeResource = childResources.next();
				    if (!(localeResource.getName().equals("jcr:content") || localeResource.getName().equals("uploads") || localeResource.getName().equals("processed")) && isFolder(localeResource)) {
                        JSONObject parentLocale = getResourceDetails(localeResource);
                        if(nextLevel != 0) 
                            parentLocale.put("childs", getChildResourceObject(localeResource, itemResource, nextLevel));
					    langObject.put(localeResource.getName(), parentLocale);
				    }
			     }
            }
		return langObject;
	}

    //Gives the Resource details - path, title and name
	private JSONObject getResourceDetails(Resource resource) throws JSONException {

        JSONObject resourceObject = new JSONObject();
        if(null != resource) {
			resourceObject.put("name", resource.getName());
			resourceObject.put("path", resource.getPath());
        	resourceObject.put("title", resource.getChild("jcr:content").getValueMap().get("jcr:title"));
        }
        return resourceObject;
	}
    
    //checks if the folder is uploadfolder
    private boolean isUploadFolder(String itemPath) {
        Matcher uploadMatch = uploadPattern.matcher(itemPath);
        Matcher processedMatch = processedPattern.matcher(itemPath);
        return (uploadMatch.find() || processedMatch.find());
    }
    
    private boolean isFolder(Resource localeResource) {
        ValueMap map = localeResource.getValueMap();
        String primaryType  = (String) map.get("jcr:primaryType");
        return (primaryType.equals("nt:folder") || primaryType.equals("sling:Folder") || primaryType.equals("sling:OrderedFolder"));
    }
    

	// to get the parent folder (Local folder) of the asset
	private Resource getParentResource(String itemParentPath, String itemChildPath, ResourceResolver resolver) {
    
        if(itemParentPath.equals("/content") || itemChildPath.equals("/content"))
            return null;
        boolean isParent = false;
		Resource childResource = resolver.resolve(itemChildPath);
        Resource parentResource = resolver.resolve(itemParentPath);
        Iterator<Resource> childIter = parentResource.listChildren();
        while(childIter.hasNext()) {
          Resource res = childIter.next();
          if(isUploadFolder(res.getPath())) {
             isParent = true;
             break;
          }
        }
    
		if (isParent) {
			return childResource;
		} else {
			childResource = getParentResource(parentResource.getParent().getPath(), parentResource.getPath(), resolver);
		}
    
		return childResource;
	}
%>