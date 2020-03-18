package com.asiainfo.dacp.task.controller;

import org.jboss.logging.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value = "/test")
public class TestController {
	
	private static final Logger logger = Logger.getLogger(TestController.class);
    
    @RequestMapping(value = "/{pagepath}", method = RequestMethod.GET)
    public String redirectPagepath(@PathVariable String pagepath) {
    	logger.info("path=test/" + pagepath);
    	return "test/" + pagepath;
    }
}
