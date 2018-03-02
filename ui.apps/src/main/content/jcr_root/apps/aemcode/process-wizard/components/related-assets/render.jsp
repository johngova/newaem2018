<%--
  Adaptation of OOTB multifield.
--%><%
%><%@include file="/libs/granite/ui/global.jsp" %><%
%><%@page session="false"
          import="java.util.HashMap,
    			  java.util.List,
                  org.apache.commons.lang.StringUtils,
                  org.apache.sling.api.wrappers.ValueMapDecorator,
                  com.adobe.granite.ui.components.AttrBuilder,
                  com.adobe.granite.ui.components.ComponentHelper,
                  com.adobe.granite.ui.components.ComponentHelper.Options,
                  com.adobe.granite.ui.components.Config,
                  com.adobe.granite.ui.components.Field,
                  com.adobe.granite.ui.components.Tag,
                  com.adobe.granite.ui.components.Value" %><%--###
Multifield
==========

.. granite:servercomponent:: /libs/granite/ui/components/foundation/form/multifield
   :supertype: /libs/granite/ui/components/foundation/form/field
   
   Multifield component allows to add/reorder/remove multiple instances of a field.
   In the simplest case this is a simple form input field (e.g. textfield, textarea) but it can also be a complex component acting as an aggregate of multiple subcomponents (e.g. address entry).
   
   The field to be included is defined in the subnode named ``field``.
   Regardless of the component used, Multifield assumes they all write to the same property (defined by the ``name`` property of the
   ``field`` subnode) thus the resulting value will always be multi value.

   When rendering existing entries, the Multifield will iterate over the multi value, get each value, set it in the
   field and let the field render it.
 
   For example if the field is a text field with a ``name`` value of "fruits", and you use Multifield to
   add three text fields and set them with values "apple", "orange" and "banana", the content node will get the following property after saving::
 
      fruits: ["apple", "orange", "banana"]
   
   If the field is a composite, it is its responsibility to concatenate the fields into one, before the form gets submitted, and to separate them again on rendering.
   
   It extends :granite:servercomponent:`Field </libs/granite/ui/components/foundation/form/field>` component.

   It has the following content structure:

   .. gnd:gnd::

      [granite:FormMultifield] > granite:FormField
      
      /**
       * The id attribute.
       */
      - id (String)

      /**
       * The class attribute. This is used to indicate the semantic relationship of the component similar to ``rel`` attribute.
       */
      - rel (String)

      /**
       * The class attribute.
       */
      - class (String)

      /**
       * The title attribute.
       */
      - title (String) i18n
      
      /**
       * Indicates if the field is mandatory to be filled.
       */
      - required (Boolean)
      
      /**
       * The name of the validator to be applied. E.g. ``foundation.jcr.name``.
       * See :doc:`validation </jcr_root/libs/granite/ui/components/foundation/clientlibs/foundation/js/validation/index>` in Granite UI.
       */
      - validation (String) multiple
      
      /**
       * ``true`` to generate the `SlingPostServlet @Delete <http://sling.apache.org/documentation/bundles/manipulating-content-the-slingpostservlet-servlets-post.html#delete>`_ hidden input based on the field name.
       */
      - deleteHint (Boolean) = true
      
      /**
       * The actual field of the Multifield.
       */
      + field
      
   Example::
   
      + myinput
        - sling:resourceType = "granite/ui/components/foundation/form/multifield"
        + field
          - sling:resourceType = "granite/ui/components/foundation/form/textfield"
          - name = "./pages"
###--%><%

Config cfg = cmp.getConfig();
ValueMap vm = (ValueMap) request.getAttribute(Field.class.getName());
log.info("******** - " + cfg.get("id", String.class));

Tag tag = cmp.consumeTag();
AttrBuilder attrs = tag.getAttrs();

attrs.add("id", cfg.get("id", String.class));
attrs.addRel(cfg.get("rel", String.class));
attrs.addClass(cfg.get("class", String.class));
attrs.add("title", i18n.getVar(cfg.get("title", String.class)));

attrs.add("role", "listbox");
attrs.add("aria-multiselectable", true);

if (cfg.get("required", false)) {
    attrs.add("aria-required", true);
}

String validation = StringUtils.join(cfg.get("validation", new String[0]), " ");
attrs.add("data-validation", validation);

attrs.addClass("coral-Multifield");
attrs.add("data-init", "multifield");

attrs.addOthers(cfg.getProperties(), "id", "rel", "class", "title", "required", "validation", "fieldLabel", "fieldDescription", "renderReadOnly", "deleteHint");

Resource field = cfg.getChild("field");

Config fieldCfg = new Config(field);
String name = fieldCfg.get("name", String.class);
Object[] values = vm.get("value", Object[].class); // don't convert; pass null for type

//Setting the values from the request attribute instead of pulling it from nodes. The below 2 lines of code changes the multi-field implementation for our wizard.
List<String> relatedAssets = (List<String>) request.getAttribute("relatedAssets");
    if(null != relatedAssets)
        values = relatedAssets.toArray(new String[relatedAssets.size()]);

%><div <%= attrs.build() %>><%
    if (cfg.get("deleteHint", true)) {
        AttrBuilder deleteAttrs = new AttrBuilder(request, xssAPI);
        deleteAttrs.add("type", "hidden");
        deleteAttrs.add("name", name + "@Delete");

        %><input <%= deleteAttrs.build() %>><%
    }
    %><ol class="coral-Multifield-list js-coral-Multifield-list"><%
	    for (int i = 0; i < values.length; i++) {
	        %><li class="coral-Multifield-input js-coral-Multifield-input" role="option" aria-selected="true"><% include(field, name, values[i], cmp, request); %></li><%
	    }
    %></ol>
    <script class="js-coral-Multifield-input-template" type="text/html"><% include(field, cmp, request); %></script>
</div><%!

private void include(Resource field, ComponentHelper cmp, HttpServletRequest request) throws Exception {
    // include the field with no value set at all
    
    ValueMap existingVM = (ValueMap) request.getAttribute(Value.FORM_VALUESS_ATTRIBUTE);
    String existingPath = (String) request.getAttribute(Value.CONTENTPATH_ATTRIBUTE);

    request.removeAttribute(Value.FORM_VALUESS_ATTRIBUTE);
    request.removeAttribute(Value.CONTENTPATH_ATTRIBUTE);
    
    cmp.include(field, new Options().rootField(false));
    
    request.setAttribute(Value.FORM_VALUESS_ATTRIBUTE, existingVM);
    request.setAttribute(Value.CONTENTPATH_ATTRIBUTE, existingPath);
}

private void include(Resource field, String name, Object value, ComponentHelper cmp, HttpServletRequest request) throws Exception {
    ValueMap map = new ValueMapDecorator(new HashMap<String, Object>());
    map.put(name, value);
    
    ValueMap existing = (ValueMap) request.getAttribute(Value.FORM_VALUESS_ATTRIBUTE);
    request.setAttribute(Value.FORM_VALUESS_ATTRIBUTE, map);
    
    cmp.include(field, new Options().rootField(false));
    
    request.setAttribute(Value.FORM_VALUESS_ATTRIBUTE, existing);
}
%>
