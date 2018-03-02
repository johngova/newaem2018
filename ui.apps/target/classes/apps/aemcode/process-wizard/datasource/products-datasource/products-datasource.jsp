<%@include file="/libs/granite/ui/global.jsp"%><%@page session="false"
	import="java.util.Map,
                  java.util.HashMap,
                  java.util.Iterator,
                  java.util.List,
                  org.apache.commons.lang.StringUtils,
                  com.adobe.granite.ui.components.Config,
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
                  org.slf4j.Logger,
                  org.slf4j.LoggerFactory,
                  org.apache.sling.api.SlingHttpServletRequest,
                  com.kyocera.kdag.pim.commerce.CommerceService,
                  com.kyocera.kdag.pim.commerce.catalog.MasterCatalog,
                  com.kyocera.kdag.pim.commerce.product.Category,
                  com.kyocera.kdag.pim.commerce.product.Product,
                  org.apache.sling.api.resource.ResourceResolver,
                  com.kyocera.kdag.pim.commerce.exception.CategoryNotFoundException, 
                  com.kyocera.kdag.pim.commerce.exception.CatalogNotFoundException,
                  java.util.regex.Matcher,
                  java.util.regex.Pattern"%>
    
    
<%
   List<String> productDataProperty = null;
    if(null != slingRequest.getAttribute("productdetails")) {
        productDataProperty = (List<String>) slingRequest.getAttribute("productdetails");
    }
   String updateCheckBoxStatus = (slingRequest.getParameterValues("item").length > 1) ? "" : (isUploadsFolder(slingRequest.getParameter("item")) ? "disabled" : "");
   final ResourceResolver resolver = resourceResolver;
   Config cfg = cmp.getConfig();
   String[] sections = cfg.get("sections", String[].class);
   CommerceService commerceService = sling.getService(CommerceService.class);
   StringBuffer buf = new StringBuffer();
   buf.append("<coral-checkbox value='true' name='updateProductAssignment' " + updateCheckBoxStatus + ">");
   buf.append("Update Product Assignment");
   buf.append("</coral-checkbox>"); 
   buf.append("</br></br>");
   try {
        out.println("<h3>Update Product Assignment</h3>");
        for(int i = 0; i < sections.length; i++){
            String categoryPath = masterCatelogPath + sections[i];
            Resource categoryResource = resourceResolver.resolve(categoryPath);
            if(null != resource) {
                ValueMap valueMap = categoryResource.getValueMap();
                if(valueMap.containsKey("jcr:title")) {
                    buf.append("<strong><font size='4'>" + valueMap.get("jcr:title") + "</font></strong>");
                    buf.append(getProductCatalogs(commerceService, resourceResolver, valueMap.get("categoryId", String.class), valueMap.get("jcr:title", String.class), productDataProperty));
                    buf.append("<br/>");
                }
            }
        }
    
        final Map<String, String> productData = new HashMap<String, String>();
        if(StringUtils.isNotBlank(buf.toString()))
            productData.put("productData", buf.toString());
        @SuppressWarnings("unchecked")
		DataSource ds = new SimpleDataSource(
				new TransformIterator(productData.keySet().iterator(), new Transformer() {
					public Object transform(Object input) {
						try {
							String lang = (String) input;
							ValueMap vm = new ValueMapDecorator(new HashMap<String, Object>());
							vm.put(lang, productData.get(lang));
							return new ValueMapResource(resolver, new ResourceMetadata(), "nt:unstructured",
									vm);
						} catch (Exception e) {
							throw new RuntimeException(e);
						}
					}
				}));
		request.setAttribute(DataSource.class.getName(), ds);
      } catch(CategoryNotFoundException e) {
        log.error("exception while pulling categories: {} ", e);
    } catch(CatalogNotFoundException e) {
        log.error("exception while pulling categories: {} ", e);
    } 
%>


    
<%! 
    final Logger log = LoggerFactory.getLogger(getClass());
    final String masterCatelogPath = "/etc/commerce/products/kdag/master-catalog/";
    private final String uploadsFolderPattern = "/content/dam/kdc/kdag(/.*/)uploads";
    private final Pattern uploadPattern = Pattern.compile(uploadsFolderPattern);
	private final String processedFolderPattern = "/content/dam/kdc/kdag(/.*/)processed";
    private final Pattern processedPattern = Pattern.compile(processedFolderPattern);
    
    private String getProductCatalogs(CommerceService commerceService, ResourceResolver resourceResolver, String categoryName, String categoryTitle, List<String> productData) throws CategoryNotFoundException, CatalogNotFoundException {
        StringBuilder accordianData = new StringBuilder();
        if(null != commerceService) {
            MasterCatalog masterCatelog = commerceService.getMasterCatalog(resourceResolver);
            List<Category> lstCategories =  masterCatelog.getProductCategoriesFromSection(categoryName);
            if(null != lstCategories) {
                Iterator<Category> catIterator = lstCategories.iterator();
                accordianData.append("<coral-accordion>");
                while(catIterator.hasNext()){
                   Category category = catIterator.next();
                   accordianData.append(getCategoryAccordian(category, categoryTitle, productData));
                }
                accordianData.append("</coral-accordion>");
            }    
        }
    return accordianData.toString();
    }
    
    //gets the UI Element of the categories
    private String getCategoryAccordian(Category category, String categoryTitle, List<String> productData) {
        String isChecked = "";
        if(null != productData && productData.contains(category.getPath())) {
           isChecked = "checked";
        }
        StringBuilder buf = new StringBuilder();
        buf.append("<coral-accordion-item>");
        buf.append("<coral-accordion-item-label>" + category.getTitle() + "</coral-accordion-item-label>");
        buf.append("<coral-accordion-item-content>");
        
    
        buf.append("<section class='coral-Form-fieldset'>");
        buf.append("<ul class='foundation-nestedcheckboxlist' data-foundation-nestedcheckboxlist-disconnected='false'>");
        buf.append("<li class='foundation-nestedcheckboxlist-item'>");
        buf.append("<div class='coral-Form-fieldwrapper coral-Form-fieldwrapper--singleline'><label class='coral-Checkbox coral-Form-field'>");
        buf.append("<input name='category:" + category.getTitle() + "' value='" + category.getPath() + "' data-validation='' class='coral-Checkbox-input' type='checkbox' " + isChecked + ">");
        buf.append("<span class='coral-Checkbox-checkmark'></span>");
        buf.append("<span class='coral-Checkbox-description'>" + category.getTitle() + "</span>");
        buf.append("</label></div>");
        List<Product> products = category.getAllProducts();
        if(null != products) {
            Iterator<Product> prodIterator = products.iterator();
            while(prodIterator.hasNext()) {
                Product product = prodIterator.next();
                buf.append("<ul class='foundation-nestedcheckboxlist' data-foundation-nestedcheckboxlist-disconnected='false'>");
                buf.append(addProductItem(product, category.getTitle(), categoryTitle, productData));
                buf.append("</ul>");
            }
        }
        buf.append("</li>");
        buf.append("</ul>");
        buf.append("</section>");
        buf.append("</coral-accordion-item-content>");
        buf.append("</coral-accordion-item>");
        return buf.toString();
    }
    
    //get the UI checkbox for products
    private String addProductItem(Product product, String subCategory, String mainCategoryTitle, List<String> productData) {
        String isChecked = "";
        if(null != productData && productData.contains(mainCategoryTitle + "/" + subCategory + "/" + product.getId() + "/" + product.getTitle())) {
           isChecked = "checked";
        }
        StringBuilder productBuf = new StringBuilder();
        if(StringUtils.isNotBlank(product.getTitle())) {
           productBuf.append("<li class='foundation-nestedcheckboxlist-item'>");
           productBuf.append("<div class='coral-Form-fieldwrapper coral-Form-fieldwrapper--singleline'><label class='coral-Checkbox coral-Form-field'>");
           productBuf.append("<input name='product:" + product.getTitle() + "' value='" + mainCategoryTitle + "/" + subCategory + "/" + product.getId() + "/" + product.getTitle() + "' data-validation='' class='coral-Checkbox-input' type='checkbox' " + isChecked + ">");
           productBuf.append("<span class='coral-Checkbox-checkmark'></span>");
           productBuf.append("<span class='coral-Checkbox-description'>" + product.getTitle() + "</span>");
           productBuf.append("</label></div>");
           productBuf.append("</li>");
           productBuf.append("<br/>");
        }        
        return productBuf.toString();
    }
    
    public boolean isUploadsFolder(String assetPath) {
		  Matcher uploadMatch = uploadPattern.matcher(assetPath);
		  Matcher processedMatch = processedPattern.matcher(assetPath);
		  return (uploadMatch.find() && !processedMatch.find());
	   }
%>