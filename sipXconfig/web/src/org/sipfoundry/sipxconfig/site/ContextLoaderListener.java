/*
 *
 *
 * Copyright (C) 2007 Pingtel Corp., certain elements licensed under a Contributor Agreement.
 * Contributors retain copyright to elements licensed under a Contributor Agreement.
 * Licensed to the User under the LGPL license.
 *
 * $
 */
package org.sipfoundry.sipxconfig.site;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;

import org.apache.log4j.PropertyConfigurator;
import org.sipfoundry.commons.log4j.SipFoundryLayout;
import org.sipfoundry.sipxconfig.common.ApplicationInitializedEvent;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * Override Spring's listener to send application initialized event
 */
public class ContextLoaderListener extends org.springframework.web.context.ContextLoaderListener {

    public void contextInitialized(ServletContextEvent event) {
        //configure log4j
        String log4jfile = this.getClass().getResource("/log4j.properties").getFile();
        PropertyConfigurator.configureAndWatch(log4jfile, SipFoundryLayout.LOG4J_MONITOR_FILE_DELAY);
        super.contextInitialized(event);
        ServletContext servletContext = event.getServletContext();
        WebApplicationContext bf = WebApplicationContextUtils
                .getWebApplicationContext(servletContext);
        // tell entire application, we're ready to run
        bf.publishEvent(new ApplicationInitializedEvent(this));
    }
}
