package com.azure.aemcode.core.use;

import com.adobe.cq.sightly.WCMUsePojo;

public class FirstUseClass extends WCMUsePojo{
	public String hi  =  "";
	@Override
	public void activate() throws Exception {
        hi= "this is my first use class";
		
	}
}
