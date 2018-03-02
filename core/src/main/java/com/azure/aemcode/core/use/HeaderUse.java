/**
 * 
 */
/**
 * @author seetha
 *
 */
package com.azure.aemcode.core.use;

import com.adobe.cq.sightly.WCMUsePojo;

public class HeaderUse extends WCMUsePojo{

	@Override
	public void activate() throws Exception {
		getProperties();
		getPageProperties();
		getCurrentPage();
		getCurrentStyle();
		
	}
	
}
