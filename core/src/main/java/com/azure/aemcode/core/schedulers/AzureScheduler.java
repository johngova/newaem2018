package com.azure.aemcode.core.schedulers;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 	Scheduler - 2 ways to implement this. 
 * 	1) scheduler.expression - using CRON expression
 * 	2) scheduler.period - using milli-seconds to execute the JOB
 * 
 * 
 *
 *
 */
@Component
@Service
@Properties({
	@Property(name = "scheduler.expression", value = "0 0/30 * * * ?", propertyPrivate = true)
	//,@Property(name = "scheduler.period", longValue = 360)
})
public class AzureScheduler implements Runnable {

	private Logger log = LoggerFactory.getLogger(getClass());
	@Override
	public void run() {
		// This method to run the JOB.
		log.debug("Called Azure Scheduler.....");
	}
}
