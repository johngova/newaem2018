<%--
  Adaptation of OOTB multifield.
--%><%
%><%@include file="/libs/granite/ui/global.jsp" %><%
%><%@page session="false"
          import="java.lang.reflect.Array,
                  java.util.HashMap,
                  org.apache.sling.api.wrappers.ValueMapDecorator,
                  com.adobe.granite.ui.components.Config,
                  com.adobe.granite.ui.components.Field" %><%

    Config cfg = cmp.getConfig();
    
    Resource field = cfg.getChild("field");

    Config fieldCfg = new Config(field);
    String name = fieldCfg.get("name", String.class);
log.info("&&&&&&& Name: {}", cmp.getValue().getContentValue(name, null));
    Object value = cmp.getValue().getContentValue(name, null); // don't convert; pass null for type


    Object[] array = new Object[0];
    if (value != null) {
        if (value.getClass().isArray()) {
            array = (Object[]) value;
        } else {
            array = (Object[]) Array.newInstance(value.getClass(), 1);
            array[0] = value;
        }
    }
    
    ValueMap vm = new ValueMapDecorator(new HashMap<String, Object>());
    vm.put("value", array);
    
    request.setAttribute(Field.class.getName(), vm);
%>