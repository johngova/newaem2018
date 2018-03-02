package com.azure.aemcode.core.listeners;

import java.util.Dictionary;
import java.util.Iterator;

import org.apache.felix.scr.annotations.Activate;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.osgi.service.component.ComponentContext;
import org.osgi.service.event.Event;
import org.osgi.service.event.EventConstants;
import org.osgi.service.event.EventHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.dam.api.DamEvent;
import com.day.cq.wcm.api.PageEvent;
import com.day.cq.wcm.api.PageModification;

/**
 * 
 * handleEvent() - This Method should be implemented to get all the details of
 * the event.
 * 
 * 
 *
 *
 */
@Component
@Service
@Properties({ @Property(name = EventConstants.EVENT_TOPIC, value = { DamEvent.EVENT_TOPIC, PageEvent.EVENT_TOPIC }) })
public class AzureEventHandler implements EventHandler {

	private Logger log = LoggerFactory.getLogger(getClass());

	@Override
	public void handleEvent(Event event) {
		String topic = event.getTopic();

		if (topic.equals(DamEvent.EVENT_TOPIC)) {

			// getting the dam-event from existing event
			DamEvent damEvent = DamEvent.fromEvent(event);
			log.debug("Dam Event path: {}", damEvent.getAssetPath());
		} else if (topic.equals(PageEvent.EVENT_TOPIC)) {

			// getting page event from existing event
			PageEvent pageEvent = PageEvent.fromEvent(event);

			// getting the page related updates from page-modifications
			Iterator<PageModification> modifications = pageEvent.getModifications();
			while (modifications.hasNext()) {
				PageModification next = modifications.next();
				log.debug("Page Event path: {}", next.getPath());
				log.debug("Page Event path: {}", next.getUserId());
			}
		}
	}

	@SuppressWarnings("rawtypes")
	@Activate
	protected void activate(ComponentContext context) {
		Dictionary properties = context.getProperties();
	}

}
