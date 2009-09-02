package jedai.business;

/*
 * Jedai Networking Framework - http://jedai.googlecode.com
 * 
 * Copyright (c) 2006-2009 by respective authors (see below). All rights reserved.
 * 
 * This library is free software; you can redistribute it and/or modify it under the 
 * terms of the GNU Lesser General Public License as published by the Free Software 
 * Foundation; either version 2.1 of the License, or (at your option) any later 
 * version. 
 * 
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY 
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License along 
 * with this library; if not, write to the Free Software Foundation, Inc., 
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
 */

import org.red5.server.api.*;
import org.springframework.security.context.SecurityContext;
import org.springframework.security.context.SecurityContextHolderStrategy;
import org.springframework.security.context.SecurityContextImpl;
import org.springframework.util.*;

public class JedaiSecurityContextHolderStrategy implements SecurityContextHolderStrategy {
	private static final String CONTEXT_ATTRIBUTE = "acegi_context";
	private static ThreadLocal<SecurityContext> contextHolder = new ThreadLocal<SecurityContext>();

	public void clearContext() {
		IConnection connection = Red5.getConnectionLocal();
		if(connection!=null){
			synchronized (connection) {
				connection.removeAttribute(CONTEXT_ATTRIBUTE);
			}
		}else{
			contextHolder.set(null);
		}
	}

	public SecurityContext getContext() {
		IConnection connection = Red5.getConnectionLocal();
		if(connection!=null){
			synchronized(connection){
				SecurityContext securityContext = (SecurityContext) connection.getAttribute(CONTEXT_ATTRIBUTE);
				if(securityContext == null){
					securityContext = new SecurityContextImpl();
					connection.setAttribute(CONTEXT_ATTRIBUTE, securityContext);
				}
				return securityContext;
			}
		}else{
	        if (contextHolder.get() == null) {
	            contextHolder.set(new SecurityContextImpl());
	        }
	        return (SecurityContext) contextHolder.get();
		}
	}

	public void setContext(SecurityContext context) {
		IConnection connection = Red5.getConnectionLocal();
		if(connection!=null){
			synchronized (connection) {
				connection.setAttribute(CONTEXT_ATTRIBUTE, context);
			}
		}else{
	       Assert.notNull(context, "Only non-null SecurityContext instances are permitted");
	       contextHolder.set(context);
		}
	}

}